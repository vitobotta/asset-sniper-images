# asset-sniper-images

Base tools :

### Subdomains

- Passive (amass, subfinder and github-subdomains and gitlab-subdomains)
- Certificate transparency (crt)
- NOERROR subdomain discovery (dnsx)
- Bruteforce (puredns with massdns)
- Permutations (Gotator, ripgen and regulator)
- JS files & Source Code Scraping (katana)
- DNS Records (dnsx)
- Google Analytics ID (AnalyticsRelationships)
- TLS handshake (tlsx)
- Recursive search (dsieve).
- DNS Zone Transfer (dig)
- DNS takeover (dnstake)
- Subdomains takeover (nuclei)
- Cloud checkers (S3Scanner and cloud_enum)

#### Docker images for Subdomains workflow
- Amass v3
- Amass v4
- analyticsrelationships
- crt
- puredns
- gotator
- ripgen
- regulator
- dnsx (optimized: projectdiscovery/dnsx:latest 25.75 MB )
- katana (optimized: projectdiscovery/katana:latest 260.33 MB )
- subfinder (optimized: projectdiscovery/subfinder:latest 23.07 MB)
- tlsx (optimized: projectdiscovery/tlsx:latest 26.08 MB)
- dsieve (not optimized quay.io/trickest/dsieve 7.1MB)
- dig (not optimized quay.io/trickest/dsieve 7.1MB)
- dnstake
- nuclei (optimized: projectdiscovery/nuclei:latest 285.49 MB)
- cloud_enum
- s3Scanner (optimized ghcr.io/sa7mon/s3scanner:v3.0.4 43 Mb)
- github-subdomains
- gitlab-subdomains


WIP 
export IMAGE=github-endpoints && ./apply-template.sh && docker build --no-cache Docker/$IMAGE/. -t $IMAGE \
    && docker run -it --rm $IMAGE /bin/sh

