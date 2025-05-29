#! /usr/bin/python3
import os, json, argparse

def main():
    # Set up argument parsing
    parser = argparse.ArgumentParser(description="Process a JSON file")
    parser.add_argument('file', type=str, help="Name of the JSON file")

    # Parse the command line arguments
    args = parser.parse_args()

    # Get the filename from the argument
    file_name = args.file
    print(f"Processing file: {file_name}")

    try:
        with open(file_name, 'r') as f:
            js_data = json.load(f)
            print("Data loaded successfully.")
    except Exception as e:
        print(f"Error reading the file: {e}")

    for el in js_data:
    	el['threshold'] = 0
#        if el['detType'] == 2:
#           el['fwhm'] = 2
        # el['fitLimits'] = [80, 500]
        #   el['amp'] = 1000
        # el['PTLimits'] = [0, 1500]

    js_new_data = json.dumps(js_data, indent=3)

    try:
        with open(f'{file_name}', 'w') as ofile:
            ofile.write(js_new_data)
            print("Data saved successfully.")
    except Exception as e:
        print(f"Error writing the file: {e}")

if __name__ == "__main__":
    main()
