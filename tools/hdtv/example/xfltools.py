"""
Tools to work with xfl files (hdtv fit list files)
"""

import xml.etree.ElementTree as ET
from uncertainties import ufloat, ufloat_fromstr
import numpy as np


class HDTVRegion:
    def __init__(self, node):
        self.node = node
        self.begin = get_cal_uncal(node.find("begin"))
        self.end = get_cal_uncal(node.find("end"))


class HDTVBackgroundRegion(HDTVRegion):
    pass


class HDTVFitRegion(HDTVRegion):
    def get_middle(self):
        return (self.end['cal'] + self.begin['cal'])/2


class HDTVPeakMarker:
    def __init__(self, node):
        self.node = node
        self.position = get_cal_uncal(node.find("position"))


class HDTVBackground:
    def __init__(self, node):
        self.chisquare = node.get("chisquare")
        self.nparams = int(node.get("nparams"))
        self.model = node.get("backgroundModel")

        self.params = {int(param.get("npar")): get_ufloat(param)
                       for param in node.findall("param")}
        self.bgfun = None
        if self.model == "polynomial":
            self.bgfun = np.poly1d(self.params)

    def __repr__(self):
        params = ', '.join([f"{deg}: {param}"
            for deg, param in self.params.items()])
        return f"HDTVBackground {self.model} (nparams={self.nparams}): {params}"

    def __call__(self, x):
        return self.bgfun(x, *self.params.values())


class HDTVPeak:
    def __init__(self, node, fitlist):
        self.fitlist = fitlist
        self.node = node
        self.uncal = {prop.tag: get_ufloat(prop)
                      for prop in node.find("uncal")}
        self.cal = {prop.tag: get_ufloat(prop)
                    for prop in node.find("cal")}
        self.extras = {extra.tag: get_ufloat(extra)
                       for extra in node.find("extras")}
        self.recal = {}
        self.match = None
        self.middle = self.cal['pos'].n

    def __repr__(self):
        if 'pos_lit' in self.extras:
            pos_lit_info = f" (pos_lit = {self.extras['pos_lit']})"
        else:
            pos_lit_info = ""
        return f"Peak @ {self.uncal['pos']} ({self.cal['pos']} keV){pos_lit_info}"


class HDTVIntegral:
    def __init__(self, node):
        self.middle = None
        self.type = node.get("integraltype")
        self.uncal = {prop.tag: get_ufloat(prop)
                      for prop in node.find("uncal")}
        try:
            self.cal = {prop.tag: get_ufloat(prop)
                        for prop in node.find("cal")}
        except TypeError:
            pass

    def __repr__(self):
        res = f"Integral @ {self.uncal['pos']}, vol = {self.uncal['vol']}"
        try:
            res += f" ({self.cal['pos']} keV)"
        except AttributeError:
            pass
        return res

    def set_middle(self, middle):
        self.middle = middle


class HDTVFit:
    def __init__(self, node, fitlist):
        self.fitlist = fitlist
        self.node = node
        self.peak_model = node.get("peakModel")
        self.calibration = [float(i) for i in
                            node.find("spectrum").get("calibration").split()]
        try:
            self.chi = float(node.get("chi"))
        except ValueError:
            self.chi = None
        self.bg = HDTVBackground(node.find("background"))
        self.backgrounds = [HDTVBackgroundRegion(el)
            for el in node.findall("bgMarker")]

        region_marker = node.find("regionMarker")
        if region_marker:
            self.region = HDTVFitRegion(region_marker)

        self.peak_markers = [HDTVPeakMarker(el)
            for el in node.findall("peakMarker")]
        self.peaks = [HDTVPeak(el, self.fitlist)
            for el in node.findall("peak")]
        self.integrals = {el.get("integraltype"): HDTVIntegral(el)
            for el in node.findall("integral")}
        for integral in self.integrals.values():
            integral.set_middle(self.region.get_middle())


class HDTVFitList:
    def __init__(self, xfl):
        self.fits = [HDTVFit(el, self) for el in xfl.findall('fit')]
    
    @classmethod
    def from_path(cls, path):
        return cls(ET.parse(path))

    def get_peaks(self):
        for fit in self.fits:
            yield from fit.peaks


def get_ufloat(node):
    try:
        nominal_value = float(node.find("value").text)
        std_dev = float(node.find("error").text)
    except AttributeError:
        return None
    try:
        tag = node.get("status")
    except AttributeError:
        tag = None
    return ufloat(nominal_value, std_dev, tag)

def get_cal_uncal(node):
    return {s: float(node.find(s).text)
            for s in ["cal", "uncal"]}
