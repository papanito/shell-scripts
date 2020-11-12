# shell scripts

## backup_simple.sh

A simple backup script to save essential configurations and data as tar file. The tar files are stored in a subdirectory in form of "YYYYMMDD" of a pre-configured backup directory.

## diskperformance.sh

A simple script to measure disk performance. The script uses `dd` to write a file n times whereas n can be specified as a parameter - default is 10. The output will be shown on the command line as well as in the logfile "diskperformance.log" which is in the same directory as the file written by `dd`.
Target directory should be specified as argument - if not `/root/` will be used so ensure you have access to it.

NOTE: this is currently only a simple test with permanent writing i.e. no random writing or reading. Therefore script needs to be extended accordingly
Examples:
```
TBD 
```
## gnome-extensions-enable.sh

Enables all gnome-shell extensions you have installed at once. This is useful after e.g. a crash of gnome-shell.

## kill-kube-ns.sh

Delete multiple namespaces in state `Terminating` by using the script [`kill-kube-ns.sh](./kill-kube-ns.sh) from Redha, which does the following

```bash
kubectl get ns | awk '/Term/ { print $1 }' | while IFS= read -r line; do ~/bin/kill-kube-ns.sh $line; done
```

Reference is [this post at stackoverflow.com](https://stackoverflow.com/questions/60230242/how-to-output-the-result-of-a-chain-of-commands-for-a-given-input-with-bash/60303522#60303522)