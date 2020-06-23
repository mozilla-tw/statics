This is a repo aiming to keep the static assets at Firebase Hosting

# Getting Started 
- Obtain Firebase token (make sure you have permission to generate token)
```
firebase login:ci
```

- Add the Firebase token to Secrets, named FIREBASE_TOKEN 

- Add an new workflow to Github Actions
```
cd $repo_dir
vi .github/workflows/deploy_to_firebase_hosting.yml

name: deploy_to_firebase_hosting

on:
  push:

jobs:
  deploy_to_firebase_hosting:

    runs-on: ubuntu-latest

    steps:
      - name: Checkout the repository
        uses: actions/checkout@master

      - name: Deploy to Firebase
        uses: w9jds/firebase-action@master
        with:
          args: deploy --only hosting
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```
- Connecting to the Firebase project to be hosting the static assets 
```
cd $repo_dir
firebase init hosting 

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

i  .firebaserc already has a default project, using msrp-dev01.

=== Hosting Setup
? What do you want to use as your public directory? public

(omit)

i  Writing configuration info to firebase.json...
i  Writing project information to .firebaserc...

✔  Firebase initialization complete!

```

- Add the pictures to /public folder, and push to repo, it'll automatically deploy pictures to hosting, ex: https://msrp-dev01.firebaseapp.com/nut.png


# Deploy to Preview/Production 
- This repo only automate the step from Github to msrp-dev01, need a person having firebase "Editor" permission of Preview and Production to deploy to those two 
```
cd $repo_dir
./deploy.sh 

firebase use rocketnightly // switch to Preview 
firebase deploy --only hosting  // upload pictures 

=== Deploying to 'rocketnightly'...

i  deploying hosting
i  hosting[rocketnightly]: beginning deploy...
i  hosting[rocketnightly]: found 29 files in public
✔  hosting[rocketnightly]: file upload complete
i  hosting[rocketnightly]: finalizing version...
✔  hosting[rocketnightly]: version finalized
i  hosting[rocketnightly]: releasing new version...
✔  hosting[rocketnightly]: release complete

✔  Deploy complete!

[ommited]

```

# TODO
1. To seperate the upload process from DEV and PROD, i.e. setup another repo for PROD uploading (only FQDNs are different)   
2. Currently the 'push' will trigger uploding process, it'll need to be changed to only RM/QA/SRE/Backend can do this. 
3. Firebase Hosting will keep files of every deployed version. We need to delete old deployed versions to prevent wasting space. (1G storage space for free) https://firebase.google.com/docs/hosting/reference/rest/v1beta1/sites.versions/delete
