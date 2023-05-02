# My Scripts

Scripts to help me do stuff. Written by me. Not for general use. Unless you want to. 

Poorly documented, barely commented and often hardcoded. Proceed at your own risk.

- [SSH Key Generation](#ssh-key-generation-script)
- [Database Initialization](#db-initialization)
- [Database Backup](#db-backup)

## ./db_init.sh
### db initialization

This script spins up a PostgreSQL database in a Docker container, generates a random password, forwards a port that is not in use, and saves all the relevant details as an env file.

Usage:
```bash
./db_init.sh [db_name] [db_user]
```
The script takes two optional arguments: the name of the database and the name of the database user. If these arguments are not provided, the script will use `default` as the database name and database user.

### Script Details:

The script performs the following steps:

1. Checks if Docker is installed and running.
2. Generates a random password for the PostgreSQL database.
3. Spins up a new PostgreSQL database in a Docker container with the specified name, user, and password.
4. Forwards a port that is not in use to the PostgreSQL container.
5. Saves the database details (including the database name, user, password, host, and port) to an `.env` file in the current directory.
6. Prints the connection string to the console.

### Example:

To spin up a new PostgreSQL database with the name `mydb` and the user `myuser`, run:
```bash
./db_init.sh mydb myuser
```

This will spin up a new PostgreSQL database with the name `mydb`, the user `myuser`, and a random password, forward a port that is not in use to the container, save the database details to an `.env` file in the current directory, and print the connection string to the console.

**NOTE:** The generated database password should be kept secret and should never be shared with anyone.

---

## ./gen_key.sh <filename> <passphrase>
### SSH Key Generation Script

This script generates a new SSH keypair using the ed25519 algorithm, adds an entry for `github.com` to the SSH config file, and prints the public key to the console.

Usage:
```bash
    ./ssh_keygen.sh [filename] [passphrase]
```

The default filename is `id_ed25519`. If no passphrase is provided, the keypair will not have a passphrase.

#### Script Details:

The script performs the following steps:

1. Checks if the `~/.ssh` directory exists and creates it if necessary.
2. Sets the filename for the keypair using the first argument if provided, or `id_ed25519` if not.
3. Checks if a passphrase was provided using the second argument and sets the `-N` option for `ssh-keygen` accordingly.
4. Generates a new SSH keypair using the `ssh-keygen` command with the ed25519 algorithm and the specified options.
5. Adds an entry for `github.com` to the SSH config file with the path to the private key file.
6. Prints the public key to the console.

#### Example:

To generate a new SSH keypair with the filename `my_key` and the passphrase `my_passphrase`, run:

    ./ssh_keygen.sh my_key my_passphrase

This will generate a new SSH keypair with the filename `my_key`, protect it with the passphrase `my_passphrase`, add an entry for `github.com` to the SSH config file, and print the public key to the console.

If you don't want to use a passphrase, omit the second argument:

    ./ssh_keygen.sh my_key

This will generate a new SSH keypair with the filename `my_key`, protect it with an empty passphrase, add an entry for `github.com` to the SSH config file, and print the public key to the console.

**NOTE:** The generated SSH key should be kept secret and should never be shared with anyone.

## ./db_backup.sh
### DB Backup

This script copies a database backup from a remote server to a local machine. The remote server is accessed via SSH and the backup is copied using rsync.

### Usage

    ./db_backup.sh db_name backup_path

### Variables

The script uses the following env variables:

- `DOMAIN_NAME`: the domain name or IP address of the remote server.
- `DB_NAME`: the name of the database to be backed up.
- `BACKUP_PATH`: the path on the local machine where the backup should be saved.
- `DB_BACKUP_PATH`: the path on the local machine where the database backup should be saved.
- `CONFIG_BACKUP_PATH`: the path on the local machine where the configuration files should be saved.
- `REMOTE_APP_PATH`: the path on the remote server where the application is installed.

## Usage

To use the script, simply run it on the local machine:

```bash
./backup.sh
