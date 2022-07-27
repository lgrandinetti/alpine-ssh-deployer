# Alpine SSH deployer

**Git Hub repository:**
<https://github.com/lgrandinetti/alpine-ssh-deployer>

##  What's included:
- ssh-client
- bash
- tar
- gzip
- curl
- jq (for helping with external json API calls parsing)
- [GitLab Secure Files](https://docs.gitlab.com/ee/ci/secure_files/index.html) download script

## Using from GitLab CI

```yml
deploy:staging:
  stage: deploy
  image: grandinetti/alpine-ssh-deployer:latest
  environment:
    name: staging
  before_script:
    - mkdir -p ~/.ssh && chmod 700 ~/.ssh
    - echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
    # Base64 decode needed you're if using gitlab masked variables. Remember that you also need to add a base64 encoded key
    - echo "$SSH_PRIVATE_KEY" | base64 -d -w 0 | ssh-add -
    - ssh-keyscan $AZURE_SSH_HOST >> ~/.ssh/known_hosts && chmod 644 ~/.ssh/known_hosts
    # Run load-secure-files script if you're using gitlab secure files. You must set the CI_PRIVATE_TOKEN with a valid gitlab API  token.
    # Optionally, you can set the SECURE_FILES_DOWNLOAD_PATH variable to specify the folder (relactive to project folder) where the files will be saved(defaults to '.secure_files')
    - load-secure-files
  script:
    # Example copying the deploy dir on the project to remote
    - scp -r deploy/. ${SSH_USER}@${SSH_HOST}:~/app
    # Example running a remote command
    - ssh ${SSH_USER}@${SSH_HOST} 'chmod 700 ~/app/app.sh'
    # Example running multiple remote commands
    - ssh ${SSH_USER}@${SSH_HOST} 'cd ~/app && docker-compose up --force-recreate -d'
```