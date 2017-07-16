# Infrastructure

- [Overview](#overview)
- [Environments](#environments)
- [Accounts](#accounts)
- [Prerequisite reading](#prerequisite-reading)
- [Bootstrapping](#bootstrapping)

The automated configuration and deployment of the full Superwatermelon
technical infrastructure used to manage source code and software artifacts,
support the build and deployment pipeline and orchestration and monitoring
of live services.

## Overview

The infrastructure is split into two sections, the internal infrastructure
and the live infrastructure. The internal infrastructure contains all of
the tooling required to support the build and deployment pipeline, this
includes:

- Jenkins CI server
- SVN and Git code repositories
- A non-HA Swarm cluster used for testing
- Elasticsearch, Kibana, InfluxDB and Grafana

> **NOTE:** These templates create AWS resources that incur charges!

## Environments

The `live` folder contains the infrastructure templates to create the
live / production environment, the same templates are also to be used
for the staging environment.

The `internal` folder contains the infrastructure templates to create
the internal development and testing environments.

## Accounts

The following AWS accounts are relevant:

<table>
  <tr>
    <th scope="row">Internal</th>
    <td>
      This account hosts the internal environment, a stable
      environment containing tools, code and artifact repositories.
    </td>
  </tr>
  <tr>
    <th scope="row">Test</th>
    <td>
      Hosts the test environment, used by the CD pipeline to
      perform an initial deployment for testing purposes.
    </td>
  </tr>
  <tr>
    <th scope="row">Staging</th>
    <td>
      Hosts the staging environment, this is a replica of the live
      environment used for testing prior to live deployment.
    </td>
  </tr>
  <tr>
    <th scope="row">Live</th>
    <td>
      Hosts the live environment.
    </td>
  </tr>
</table>

## Live VPCs

<table>
  <tr>
    <th scope="row">`app`</th>
    <td>Hosts the deployed applications.</td>
  </tr>
  <tr>
    <th scope="row">`data`</th>
    <td>Hosts the databases for the applications.</td>
  </tr>
  <tr scope="row">
    <th scope="row">`gateway`</th>
    <td>
      Hosts traffic and API management systems used to manage
      access to the applications.
    </td>
  </tr>
</table>

## Test VPCs

<table>
  <tr>
    <th scope="row">`test`</th>
    <td>Hosts the environment used for internal testing.</td>
  </tr>
</table>

## Internal VPCs

<table>
  <tr>
    <th scope="row">`tools`</th>
    <td>
      Hosts the code, repositories and automation tools for
      development.
    </td>
  </tr>
  <tr>
    <th scope="row">`ops`</th>
    <td>
      Hosts the operational tools, such as monitoring tools and
      databases.
    </td>
  </tr>
</table>

## Prerequisite reading

- Terraform https://www.terraform.io/intro/
- AWS VPC http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Introduction.html
- CoreOS https://coreos.com/docs
- Ignition https://coreos.com/ignition/docs/latest/
- systemd https://www.freedesktop.org/wiki/Software/systemd/
- Docker Swarm https://docs.docker.com/engine/swarm/

## Bootstrapping

The `Makefile` in this project handles the bootstrapping of the accounts, the
following variables need to be set. The developer running the bootstrapping
will (at least temporarily) need access to all accounts, **Internal**,
**Test**, **Stage** and **Live**. To be able to create an IAM role and S3
bucket.

<table>
  <tr>
    <th scope="row"><code>INTERNAL_AWS_PROFILE</code></th>
    <td>
      The AWS profile to use when bootstrapping the **Internal** account, there
      should be a corresponding entry in your <code>~/.aws/credentials</code>
      file that specified the keys to use to access the account. See
      [AWS Named Profiles][aws-named-profiles] for details.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>TEST_AWS_PROFILE</code></th>
    <td>
      The AWS profile to use when bootstrapping the **Test** account, there
      should be a corresponding entry in your <code>~/.aws/credentials</code>
      file that specified the keys to use to access the account. See
      [AWS Named Profiles][aws-named-profiles] for details.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>STAGE_AWS_PROFILE</code></th>
    <td>
      The AWS profile to use when bootstrapping the **Stage** account, there
      should be a corresponding entry in your <code>~/.aws/credentials</code>
      file that specified the keys to use to access the account. See
      [AWS Named Profiles][aws-named-profiles] for details.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>LIVE_AWS_PROFILE</code></th>
    <td>
      The AWS profile to use when bootstrapping the **Live** account, there
      should be a corresponding entry in your <code>~/.aws/credentials</code>
      file that specified the keys to use to access the account. See
      [AWS Named Profiles][aws-named-profiles] for details.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>INTERNAL_TFSTATE_BUCKET</code></th>
    <td>
      The name to give the S3 bucket that will hold the Terraform state for
      the **Internal** infrastructure. This bucket will be created if it
      doesn't exist and versioning will be enabled.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>TEST_TFSTATE_BUCKET</code></th>
    <td>
      The name to give the S3 bucket that will hold the Terraform state for
      the **Test** infrastructure. This bucket will be created if it
      doesn't exist and versioning will be enabled.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>STAGE_TFSTATE_BUCKET</code></th>
    <td>
      The name to give the S3 bucket that will hold the Terraform state for
      the **Stage** infrastructure. This bucket will be created if it
      doesn't exist and versioning will be enabled.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>LIVE_TFSTATE_BUCKET</code></th>
    <td>
      The name to give the S3 bucket that will hold the Terraform state for
      the **Live** infrastructure. This bucket will be created if it
      doesn't exist and versioning will be enabled.
    </td>
  </tr>
  <tr>
    <th scope="row"><code>AWS_REGION</code></th>
    <td>
      The AWS region that will host the S3 buckets holding the Terraform state.
    </td>
  </tr>
</table>

The default target will check that the required variables are set and retrieve
the internal principal.

```sh
make
```

If any variables are missing you will see errors as follows:

```
Makefile:5: *** INTERNAL_AWS_PROFILE is undefined.  Stop.
```

Provide the values relevant for your infrastructure and when ready, run the
init target:

```sh
make init
```

This will create the required roles and S3 buckets for deployment. At which
point you will be ready to trigger the deployment of the
[**Internal** infrastructure][infrastructure-internal].

[aws-named-profiles]: http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#cli-multiple-profiles
[infrastructure-internal]: https://github.com/superwatermelon/infrastructure-internal
