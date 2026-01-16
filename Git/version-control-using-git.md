# Version Control using Git

## Situation Before Version Control

In a typical project, there were three roles:
- Frontend Developer
- Backend Developer
- DevOps / Operations

Work happened in sequence, not in parallel.

- Frontend created HTML, CSS, and JavaScript files.
- Files were manually sent to Backend.
- Backend worked on server and database (PHP, MySQL).
- After changes, files were sent back to Frontend again.
- At the end, Operations deployed everything to the server.

If a bug appeared:
- The whole project returned to developers.
- No clear history of changes.
- High risk of breaking working code.
- Time wasted on file copying and re-uploading.

This workflow did not scale.

---

## Why Version Control Is Important

### 1) Working at the Same Time

Multiple engineers work on the same project in parallel.

Common platforms:
- GitHub
- GitLab
- Bitbucket

The project is stored in a repository (private or public).

- Frontend → UI files
- Backend → API and database code
- DevOps → Docker, CI/CD, Terraform

All changes are visible and tracked.

---

### 2) Returning to Any Previous Version

Without Git:
- Hard to know what changed.
- Hard to undo broken features.

With Git:
- Every change is stored as a commit.
- Any old version can be restored.
- Broken changes can be rolled back safely.

---

### 3) Branches

Branches separate work inside one repository.

Common structure:
- main → stable production code
- dev → daily development
- testing → experiments

Benefits:
- main stays stable.
- New work does not break production.
- Features are merged only when ready.

---

### 4) Conflict Handling

If two people edit the same file:
- Git detects a conflict.
- Changes must be reviewed and resolved.
- No silent overwrites.
- No lost work.

---

### 5) Testing Without Risk

New features are tested in separate branches.

- If successful → merge
- If failed → delete branch

No impact on stable code.

---

### 6) Git with Hosting (cPanel or Server)

Git can be connected to a hosting server.

Workflow:
- Push changes to GitHub
- Pull changes on the server
- Website updates automatically

Old method:
- Delete files
- Upload files manually
- High risk of mistakes

---

## Git Commands 

### Create README File
bash
echo "# github-project" >> README.md
Creates a README.md file and adds a basic project description used by GitHub.

### Initialize Git Repository
bash
git init
Turns the current directory into a Git repository and starts tracking changes.

### Add File to Tracking
bash
git add README.md
Marks the file to be included in the next commit.

### Save Snapshot (Commit)
bash
git commit -m "first commit"
Saves the current project state into Git history.

### Rename Main Branch
bash
git branch -M main
Sets the default branch name to main.

### Connect to Remote Repository
bash
git remote add origin <repository-url>
Links the local repository to a remote Git server.

### Push to Remote
bash
git push -u origin main
Uploads the local commits to the remote repository and sets the default push branch.

### Check Project State
bash
git status
Displays tracked, modified, staged, and untracked files.

### Add All Files
bash
git add .
Stages all current changes in the project directory.

### Commit New Changes
bash
git commit -m "adding docker files"
Saves the newly staged changes into the project history.

### Push Updates
bash
git push
Sends the latest commits to the remote repository.

### Create and Switch Branch
bash
git checkout -b dev
Creates a new branch named dev and switches to it.

### List Branches
bash
git branch
Shows all local branches and highlights the active one.

### Push Branch to Remote
bash
git push --set-upstream origin dev
Uploads the dev branch and links it to the remote repository.

### Switch Branch
bash
git checkout main
Switches the working directory to the main branch.

### Delete Local Branch
bash
git branch -d testing
Removes a local branch from the repository.

### .gitignore
bash
touch .gitignore
Creates a file that defines which files Git should ignore and never track.

---

## Additional References

- [git-commands – Command Reference](git-commands.md)
