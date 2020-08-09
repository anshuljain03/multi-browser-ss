# Cross browser screenshots

## Aim

Take a website link from a user, and take a screenshot of that website on multiple browsers. Return a presigned S3 link to the user

## Implementation Details
1. This


## Pre-requisites
1. #### Node > 10.x
    ```sh
    node -v
    ```
    To check if node is installed. If not download from [here](https://nodejs.org/en/download/current/)
2. #### Docker agent
    ```sh
    docker -v
    ```
    To check if docker is installed and running. If not download from [here](https://docs.docker.com/get-docker/)
3. #### AWS CLI v1
    ```sh
    aws --version
    ```
    To check if aws-cli is installed. If not download from [here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)


## How to run it
1. Ensure that all the above mentioned tools have been installed
2. Clone using the following command
    ```sh
    git clone https://github.com/anshuljain03/multi-browser-ss.git
    ```
3. Add your AWS access keys and S3 bucket in `run.sh`
4. Run the script using
    ```sh
    bash ./multi-browser-ss/run.sh
    ```
