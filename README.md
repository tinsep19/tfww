# tfww (Terraform Workspace Wrapper)

`tfww` is a shell script that simplifies the use of Terraform's workspace functionality. It wraps Terraform to enforce a structured directory layout, making workspace switching and application easier.

## Expected Directory Structure

```
+ (project-root)
  + envs/${workspace}.tfvars
  + main.tf
  + some.auto.tfvars
```

When using Terraform's workspace feature and expressing all environment differences in `tfvars` files, you should create a `${workspace}.tfvars` file and place it in the `envs` directory.

## Usage

1. Use the `tfww` script to automatically switch Terraform workspaces and apply configurations.

   ```sh
   tfww apply envs/${workspace}.tfvars
   ```

   This is equivalent to manually running:

   ```sh
   terraform workspace select ${workspace}
   terraform apply -var-file=envs/${workspace}.tfvars
   ```

2. Other Terraform commands can also be executed via `tfww`:

   ```sh
   tfww plan envs/${workspace}.tfvars
   tfww destroy envs/${workspace}.tfvars
   ```

## Installation

1. Download the latest binary from [GitHub Releases](https://github.com/tinsep19/tfww/releases).

2. Grant execution permission to the downloaded binary.

   ```sh
   chmod +x tfww
   ```

3. Move it to a directory in your system's PATH to use it globally.

   ```sh
   mv tfww /usr/local/bin/
   ```

4. Enable Bash completion by running:

   ```sh
   eval "$(tfww completions)"
   ```

   To enable completion automatically on shell startup, add this to your `.bashrc` or `.bash_profile`:

   ```sh
   echo 'eval "$(tfww completions)"' >> ~/.bashrc
   ```

## Contributing

Bug reports and feature requests are welcome via Issues. Pull requests are also encouraged.

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
