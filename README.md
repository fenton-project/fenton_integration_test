# fenton_integration_test

A testing framework to validate ssh certificate are properly handled in the Fenton Project.

## Usage

### Build/Converge Servers

```sh
kitchen converge server
kitchen converge shell
kitchen converge machine-ubuntu-1404 # choose 1 operating system per test run
```

### Test SSH

 Run inspec to validate Fenton CLI on the shell node will successfully SSH into the machine node

 ```sh
kitchen verify shell
 ```

### Debug the fenton server logs

```sh
kitchen exec server -c "tail -F /fenton_server/log/server.log"
```

### Test them all

```sh
function run_command {
  "$@"
  local command_status=$?
  
  if [ $command_status -ne 0 ]; then
    exit $command_status
  fi
  
  return $command_status
}

kitchen converge server
kitchen converge shell

for machine in `kitchen list | grep machine- | awk '{print $1}'`
do
  run_command kitchen converge $machine
  run_command kitchen verify shell
  run_command kitchen destroy $machine
done
```
