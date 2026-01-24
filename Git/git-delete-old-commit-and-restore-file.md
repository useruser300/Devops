# Lab: Delete an Old Commit and Restore a Deleted File’s Content

## Goal
- Delete an old commit (the one before the last commit) that was already pushed to GitHub
- Make the commit and its file disappear from GitHub history
- Restore only the file content later, without restoring the deleted commit

---

## Phase 1: Delete an Old (Pushed) Commit from GitHub History

### 1) Open an interactive rebase for the last 2 commits
```bash
git rebase -i HEAD~2
```

You will see something like:
```text
pick AAA111 vagrant
pick BBB222 last commit
```

### 2) Remove the commit you want to delete
Change it to:
```text
drop AAA111 vagrant
pick BBB222 last commit
```

Save and exit.

### 3) Push the rewritten history to GitHub
```bash
git push --force-with-lease
```

Result:
- The deleted commit disappears from GitHub history
- The file inside it also disappears (if it only existed in that commit)

---

## Phase 2: Confirm the Deleted Commit Still Exists Locally (Reflog)

### Check reflog
```bash
git reflog
```

Example:
```text
25a8201 commit: vagrant
```

Meaning:
- The commit is removed from visible history
- The commit still exists locally (temporary reference) and can be used to restore content

---

## Phase 3: Restore Only the File Content (Without Restoring the Old Commit)

### 1) See which files were inside the deleted commit
```bash
git show --name-only 25a8201
```

### 2) Restore the file from the deleted commit
```bash
git checkout 25a8201 -- path/to/file
```

Example:
```bash
git checkout 25a8201 -- Vagrantfile
```

### 3) Commit it again as a new commit and push it
```bash
git add path/to/file
git commit -m "Restore vagrant file content"
git push
```

Result:
- The file content is back on GitHub
- The old deleted commit stays deleted
- The history stays clean

---

## Faster Alternative: View the File Content Only (No Restore)

If you only want to read/copy the file content without restoring it into the project:
```bash
git show 25a8201:path/to/file
```

Result:
- Shows the file content exactly as it was in that commit
- Does not restore the file into the working directory
- Does not create any new commit
