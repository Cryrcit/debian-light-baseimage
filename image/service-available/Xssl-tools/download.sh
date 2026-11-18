#!/bin/bash -e

if [ ${CFSSL_VERSION} is null ]; then
  CFSSL_VERSION=1.5.0
fi

CFSSL_VERSION=${CFSSL_VERSION}
#CFSSL_VERSION=1.5.0
#CFSSL_VERSION=1.6.5

echo "CFSSL version is ${CFSSL_VERSION}"

UARCH=$(uname -m)
echo "Architecture is ${UARCH}"

case "${UARCH}" in
    
    "x86_64")
        HOST_ARCH="amd64"
    ;;
    
    "arm64" | "aarch64")
        HOST_ARCH="arm64"
    ;;
    
    "armv7l" | "armv6l" | "armhf")
        HOST_ARCH="arm"
    ;;
    
    "i386")
        HOST_ARCH="386"
    ;;
    
    *)
        echo "Architecture not supported. Exiting."
        exit 1
    ;;
esac

#CFSSL_SCAN_VERSION=v${CFSSL_VERSION}/cfssl-scan_${CFSSL_VERSION}_linux_${HOST_ARCH}
CFSSL_SCAN_VERSION=v${CFSSL_VERSION}/cfssl_${CFSSL_VERSION}_linux_${HOST_ARCH}
CFSSL_JSON_VERSION=v${CFSSL_VERSION}/cfssljson_${CFSSL_VERSION}_linux_${HOST_ARCH}

echo "Going to use ${HOST_ARCH} cfssl binaries"

# download curl and ca-certificate from apt-get if needed
to_install=()

if [ "$(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    to_install+=("curl")
fi

if [ "$(dpkg-query -W -f='${Status}' ca-certificates 2>/dev/null | grep -c "ok installed")" -eq 0 ]; then
    to_install+=("ca-certificates")
fi

if [ ${#to_install[@]} -ne 0 ]; then
    LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${to_install[@]}"
fi

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssl jq

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=923479
if [[ "${HOST_ARCH}" == 'arm' ]]; then
    LC_ALL=C DEBIAN_FRONTEND=noninteractive c_rehash
fi

echo "Download cfssl ..."
echo "curl -o /usr/sbin/cfssl -SL https://github.com/cloudflare/cfssl/releases/download/${CFSSL_SCAN_VERSION}"
curl -o /usr/sbin/cfssl -SL "https://github.com/cloudflare/cfssl/releases/download/${CFSSL_SCAN_VERSION}"
chmod 700 /usr/sbin/cfssl

echo "Download cfssljson ..."
echo "curl -o /usr/sbin/cfssljson -SL https://github.com/cloudflare/cfssl/releases/download/${CFSSL_JSON_VERSION}"
curl -o /usr/sbin/cfssljson -SL "https://github.com/cloudflare/cfssl/releases/download/${CFSSL_JSON_VERSION}"
chmod 700 /usr/sbin/cfssljson

echo "Project sources: https://github.com/cloudflare/cfssl"

# remove tools installed to download cfssl
if [ ${#to_install[@]} -ne 0 ]; then
    apt-get remove -y --purge --auto-remove "${to_install[@]}"
fi
