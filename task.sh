#!/usr/bin/bash -x

case "$1" in
	"push")
		if [ "$2" = "--no-dry" ]; then
			rsync -av --exclude-from="${HOME}/task/.rsyncignore" -e "ssh -i ${taskCredential}" ~/task/ "${USER}@${taskServer}":~/task --update --delete
		else
			rsync -av -e "ssh -i ${taskCredential}" --exclude-from="${HOME}/task/.rsyncignore" ~/task/ "${USER}@${taskServer}":~/task --update --delete --dry-run
			read -p "sync remote data? [Y/n]: " x
			if [ "$x" == 'Y' ]; then
				rsync -av --exclude-from="${HOME}/task/.rsyncignore" -e "ssh -i ${taskCredential}" ~/task/ "${USER}@${taskServer}":~/task --update --delete
			fi
		fi
		;;
	"pull")
		if [ "$2" = "--no-dry" ]; then
			rsync -av --exclude-from="${HOME}/task/.rsyncignore" -e "ssh -i ${taskCredential}" "${USER}@${taskServer}":~/task/ ~/task --update --delete
		else
			rsync -av --exclude-from="${HOME}/task/.rsyncignore" -e "ssh -i ${taskCredential}" "${USER}@${taskServer}":~/task/ ~/task --update --delete --dry-run
			read -p "sync local data? [Y/n]: " x
			if [ "$x" == 'Y' ]; then
				rsync -av --exclude-from="${HOME}/task/.rsyncignore" -e "ssh -i ${taskCredential}" "${USER}@${taskServer}":~/task/ ~/task --update --delete
			fi
		fi
		;;
	*)
		echo "usage:"
		echo "task push [--no-dry]"
		echo "task pull [--no-dry]"
		;;
esac
