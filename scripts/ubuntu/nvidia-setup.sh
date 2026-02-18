# Configure the APT repository
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg &&
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list |
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' |
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list &&
    sudo apt-get update

# Install the NVIDIA Container Toolkit package
sudo apt-get install -y nvidia-container-toolkit

# Configure the Docker container runtime to use the NVIDIA container runtime
sudo nvidia-ctk runtime configure --runtime=docker
# Restart the docker daemon to propagate the runtime changes.
# NOTE: This will teardown all currently running containers!
sudo systemctl restart docker

sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
