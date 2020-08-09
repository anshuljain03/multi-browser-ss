# Cross browser screenshots

## Aim

Take a website link from a user, and take a screenshot of that website on multiple browsers. Return a presigned S3 link to the user

## Implementation Details
1. The entry point of the program is the `run.sh` bash script
2. The website link is taken as a user input
3. The script then verifies that the link is valid by making a `HEAD` request. The program exits with the message to enter a valid link if this request fails
4. It then checks whether port 4443 and 4444 are available to use or not. If yes, then both the containers (one with chrome and one with firefox are spun up)
    ##### Note: The script assumes that if port 4443 and 4444 are already in use then the respective containers are already up. This might not be a great assumption to make in general
5. Required `npm` modules are installed. This is to ensure the `NodeJS` script to take screenshots runs without a hitch
6. The script to take screenshots is then run. The script ensures that the urls start with `http://` or `https://` since the `selenium-webdriver` doesn't work with links like `google.com`
7. Once the screenshots have been taken they are uploaded to S3 and a presigned link is created for access. This link is valid for `30 minutes`


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
