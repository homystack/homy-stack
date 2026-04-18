# gitea

Self-hosted Git service for Cozystack. Wraps the upstream [Gitea Helm chart](https://dl.gitea.com/charts) and wires Postgres and Redis through the native cozystack sibling CRs (`Postgres`, `Redis`) instead of the Bitnami subcharts shipped upstream.

## Parameters

### Common parameters

| Name           | Description                                                                                             | Type     | Value |
| -------------- | ------------------------------------------------------------------------------------------------------- | -------- | ----- |
| `host`         | External hostname for the Gitea HTTP ingress. When empty the upstream chart does not create an Ingress. | `string` | `""`  |
| `storageClass` | StorageClass used by the Gitea repository PVC and by the Postgres and Redis sibling CRs.                | `string` | `""`  |


### Repository storage

| Name           | Description                                          | Type       | Value  |
| -------------- | ---------------------------------------------------- | ---------- | ------ |
| `storage`      | Gitea repository PVC configuration.                  | `object`   | `{}`   |
| `storage.size` | Persistent Volume Claim size for repository storage. | `quantity` | `10Gi` |


### Admin user

| Name             | Description                                                          | Type     | Value         |
| ---------------- | -------------------------------------------------------------------- | -------- | ------------- |
| `admin`          | Gitea admin user configuration.                                      | `object` | `{}`          |
| `admin.username` | Admin username.                                                      | `string` | `gitea_admin` |
| `admin.email`    | Admin email.                                                         | `string` | `gitea@local` |
| `admin.password` | Optional password. When empty, the upstream chart autogenerates one. | `string` | `""`          |


### SSH access

| Name          | Description                                    | Type     | Value   |
| ------------- | ---------------------------------------------- | -------- | ------- |
| `ssh`         | Gitea SSH service configuration.               | `object` | `{}`    |
| `ssh.enabled` | Expose SSH on port 22 via a dedicated Service. | `bool`   | `false` |


### Database configuration (managed via the cozystack `Postgres` sibling CR)

| Name                | Description                                                                                              | Type       | Value   |
| ------------------- | -------------------------------------------------------------------------------------------------------- | ---------- | ------- |
| `database`          | PostgreSQL database configuration.                                                                       | `object`   | `{}`    |
| `database.size`     | Persistent Volume size for database storage.                                                             | `quantity` | `10Gi`  |
| `database.replicas` | Number of PostgreSQL replicas.                                                                           | `int`      | `2`     |
| `database.user`     | Database user to create.                                                                                 | `string`   | `gitea` |
| `database.name`     | Database name to create.                                                                                 | `string`   | `gitea` |
| `database.password` | Optional password. When empty, the cozystack postgres chart generates one and preserves it via `lookup`. | `string`   | `""`    |


### Redis configuration (optional, managed via the cozystack `Redis` sibling CR)

| Name             | Description                                                                                                        | Type       | Value  |
| ---------------- | ------------------------------------------------------------------------------------------------------------------ | ---------- | ------ |
| `redis`          | Redis configuration.                                                                                               | `object`   | `{}`   |
| `redis.enabled`  | Enable the managed Redis sibling CR. When false, no Redis is provisioned and Gitea uses memory and level defaults. | `bool`     | `true` |
| `redis.size`     | Persistent Volume size for Redis storage.                                                                          | `quantity` | `1Gi`  |
| `redis.replicas` | Number of Redis replicas.                                                                                          | `int`      | `2`    |

