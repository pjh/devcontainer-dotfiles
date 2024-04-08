# Aliases: use an alias as a kind of shortcut: when you always want to
# substitute some extended command for a simple existing command.
# New commands should be added using shell functions, below.
function echo-run-cmd {
  CMD="$@"
  echo $CMD
  $CMD
}

##############################################################################
function viless {
  # e.g. "grep something somefile | viless"
  vi -R -
}
function vi-noplugins {
  vi --noplugin $@
}
function rsync-pdfpng {
  rsync -avzr --include="*/" --include="*.pdf" --include="*.png" \
  --exclude="*" $@
}
function rsync-compressed {
  rsync -avzr $@
}
function rsync-normal {
  rsync -avr $@
}
function lst {
  ls -hlt $2 | head -n $1
}
function add-path {
  export PATH=$PATH:`pwd`
}
function tex-fmt {
  fmt -s $@
}

# ssh:
function ssh-start-agent-and-save-password {
  eval `ssh-agent`
  echo-run-cmd ssh-add ~/.ssh/id_ed25519
}
function start-ssh-agent-and-save-password {
  ssh-start-agent-and-save-password $@
}

# git:
function gt {
  git town $@
}
function git-status-hide-untracked {
  git status --untracked-files=no
}
function git-log {
  git log $@ > git.log
  $EDITOR git.log
}
function git-log-online {
  git log --format=oneline
}
function git-diff-unstaged {
  #git diff $@ | vi -R -
  git diff $@ > git.diff
  $EDITOR git.diff
}
function git-diff-staged {
  #git diff --cached $@ | vi -R -
  git diff --cached $@ > git.diff
  $EDITOR git.diff
}
function git-diff-notpushed {
  git diff @{upstream}.. $@ > git.diff
  $EDITOR git.diff
}
function git-diff-from-master {
  git diff master.. > git.diff
  $EDITOR git.diff
}
function git-log-notpushed {
  # http://stackoverflow.com/questions/2016901/viewing-unpushed-git-commits
  git log @{upstream}.. $@ > git.log
  $EDITOR git.log
}
function git-unstage-all {
  echo-run-cmd 'git restore --staged .'
}
function git-branches {
  git branch --color -v
}
function git-branch-diagram {
  git log --graph --oneline --all
}
function git-show-latest-commit {
  #git log -n 1 | head -n 1 | awk '{print $2}' | xargs git show
  #git log -n 1 | head -n 1 | awk '{print $2}' | xargs git show | viless
  #git log -n 1 | head -n 1 | awk '{print $2}' | xargs git show | vi -c "WhitespaceHighlight off" -R -
  #git log -n 1 | head -n 1 | awk '{print $2}' | xargs git show | vi -c -R -
  git log -n 1 | head -n 1 | awk '{print $2}' | xargs git show | $EDITOR
}
function git-cherry-pick-interactive {
  # http://stackoverflow.com/a/1526093/1230197
  # Use '?' in interactive mode to see help.
  git cherry-pick -n $1 &&  # get your patch, but don't commit
                            # (-n = --no-commit)
  git reset             &&  # unstage the changes from the cherry-
                            # picked commit
  git add -p            &&  # make all your choices (add the changes
                            # you do want)
  echo "Now git commit -m \"...\", then (probably) unstage any pending changes with git checkout -- cloud/vmm/*"
}

function git-sync-help {
  echo "# Sync master:"
  echo "git fetch upstream"
  echo "git checkout master"
  echo "# git merge upstream/master  # Old way"
  echo "# Suggested by https://github.com/kubernetes/community/blob/master/contributors/guide/github-workflow.md#4-keep-your-branch-in-sync:"
  echo "git rebase upstream/master"
  echo "git push origin"
  echo "# Cleanup old merged branches:"
  echo "git fetch --prune --all"
  echo "# Sync a branch w/ upstream/master:"
  echo "git checkout windows-up"
  echo "git checkout -b sync-windows-up  # optional PR branch."
  echo "git merge master"
  echo "git push --set-upstream origin sync-windows-up"
}

function gcloud-configurations-list {
  gcloud config configurations list --format="(name:sort=1, properties.core.project, properties.core.account)"
}
function gcloud-update {
  echo-run-cmd gcloud components update --quiet
}

function git-commit-all-amend {
  echo-run-cmd git commit -a --amend $@
}
function git-branch-tracking-branch {
  if [[ "$#" -ne 1 ]]; then
    echo "git branch track-release-1.xx remotes/origin/release-1.xx"
    echo "Must pass 'release-1.xx' as an arg"
    return
  else
    release=$1
  fi
  echo-run-cmd git branch track-$release remotes/origin/$release
        echo-run-cmd git checkout track-$release
}

function filter-color-control-characters {
  # https://stackoverflow.com/a/18000433/1230197
  # No idea what this is doing but it works when I do:
  #  cat text-file-with-color-output.txt | filter-color-control-characters
  #sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g"
  # Possibly better: https://stackoverflow.com/a/51141872/1230197
  # This will catch anything that starts with [, has any number of
  # decimals and semicolons, and ends with a letter. This should catch
  # any of the common ANSI escape sequences
  # [https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_sequences].
  sed 's/\x1B\[[0-9;]\+[A-Za-z]//g'
}
function better-which {
  echo-run-cmd "type $@"
}
