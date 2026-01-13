#!/usr/bin/env python3
"""Install a specific version of Hugo"""

import argparse
import json
import os
import platform
import shutil
import subprocess
import sys
import tarfile
import tempfile
from urllib.error import URLError
from urllib.request import Request, urlopen

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))


def get_latest_hugo_version():
    """Get the latest Hugo version from GitHub API"""
    headers = {"Accept": "application/vnd.github.v3+json", "User-Agent": "hugo-installer"}
    token = os.environ.get("GITHUB_TOKEN", "")
    if token:
        headers["Authorization"] = f"token {token}"
    try:
        req = Request("https://api.github.com/repos/gohugoio/hugo/releases/latest", headers=headers)
        response = urlopen(req)
        data = json.loads(response.read().decode())
        return data["tag_name"].lstrip("v")
    except URLError as e:
        print(f"Error fetching latest version from GitHub API: {e}")
        return None


def get_download_url(version):
    """Construct the download URL based on OS and architecture"""
    system = platform.system().lower()
    arch = platform.machine().lower()
    if system != "linux":
        print(f"This script currently supports Linux only. Detected: {system}")
        return None
    if arch in ["x86_64", "amd64"]:
        arch = "amd64"
    elif arch in ["aarch64", "arm64"]:
        arch = "arm64"
    else:
        print(f"Unsupported architecture: {arch}")
        return None
    # TODO: This would be retrieved from the release API call itself.
    filename = f"hugo_{version}_linux-{arch}.tar.gz"
    return f"https://github.com/gohugoio/hugo/releases/download/v{version}/{filename}"


def install_hugo(download_url):
    """Download and install Hugo to current working directory from HTTP stream"""
    print(f"Downloading and extracting {download_url}")
    try:
        response = urlopen(Request(download_url, headers={"User-Agent": "hugo-installer"}))
        with tempfile.NamedTemporaryFile(delete=False) as temp_file:
            temp_filename = temp_file.name
            shutil.copyfileobj(response, temp_file)
        try:
            with tarfile.open(temp_filename, mode="r:gz") as tar:
                try:
                    hugo_member = next(member for member in tar.getmembers() if member.name == "hugo" and member.isfile())
                except StopIteration:
                    print("Hugo binary not found in archive", file=sys.stderr)
                    return False
                install_path = os.path.join(os.getcwd(), "hugo")
                with open(install_path, "wb") as output_file:
                    shutil.copyfileobj(tar.extractfile(hugo_member), output_file)
                os.chmod(install_path, 0o755)
        finally:
            os.unlink(temp_filename)
        return True
    except URLError as e:
        print(f"Error downloading or extracting file: {e}", file=sys.stderr)
        return False


def main():
    parser = argparse.ArgumentParser(description=sys.modules[__name__].__doc__)
    parser.add_argument("--version", "-v", help="Specify the Hugo version to install (e.g., 0.153.1). If not provided, installs the latest version.")
    args = parser.parse_args()

    if platform.system().lower() != "linux":
        print(f"This script currently supports Linux only. Detected: {platform.system()}", file=sys.stderr)
        return 1
    os.chdir(os.path.join(SCRIPT_DIR, ".."))

    # Use the specified version or fetch the latest if not provided
    if args.version:
        version = args.version
        print(f"Installing specified Hugo version: {version}")
    else:
        version = get_latest_hugo_version()
        if not version:
            print("Failed to get the latest Hugo version", file=sys.stderr)
            return 1
        print(f"Latest Hugo version: {version}")

    download_url = get_download_url(version)
    if not download_url:
        print("Failed to construct download URL", file=sys.stderr)
        return 1
    if not install_hugo(download_url):
        print("Installation failed", file=sys.stderr)
        return 1
    result = subprocess.run(["./hugo", "version"], capture_output=True, text=True)
    if result.returncode:
        print(f"Warning: Could not verify installation: {result.stderr.strip()}", file=sys.stderr)
        return result.returncode
    return 0


if __name__ == "__main__":
    sys.exit(main())
