export BUILDAH_FORMAT="docker"
sudo docker build -f Containerfile --format=docker -t ca-manager:3.0 .
     
