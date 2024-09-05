import hashlib
import requests
from bs4 import BeautifulSoup

def calculate_md5(file_path):
    """Calculate the MD5 checksum of a file."""
    hash_md5 = hashlib.md5()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_md5.update(chunk)
    return hash_md5.hexdigest()

def fetch_current_md5_from_github():
    """Fetch the current MD5 checksum from the GitHub page."""
    url = "https://github.com/firegoaway/Zmejka#актуальная-хэш-сумма"
    response = requests.get(url)
    
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        text = soup.get_text()
        # Search for the line containing "ZmejkaFDS.exe"
        for line in text.splitlines():
            if "ZmejkaFDS.exe" in line:
                parts = line.split('-')
                if len(parts) > 1:
                    md5_from_site = parts[1].strip()
                    return md5_from_site
    return None

def main():
    file_path = r'..\ZmejkaFDS.exe'

    md5_local = calculate_md5(file_path)
    md5_online = fetch_current_md5_from_github()

    if md5_online:
        print(f"MD5 from file: {md5_local}")
        print(f"MD5 from GitHub: {md5_online}")

        if md5_local == md5_online:
            print("The MD5 checksums match.")
        else:
            print("The MD5 checksums do not match.")
    else:
        print("Could not fetch the MD5 checksum from GitHub.")

if __name__ == "__main__":
    main()
