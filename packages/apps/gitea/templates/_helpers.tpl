{{/*
Resolve the Gitea admin password.

Precedence:
  1. Use `.Values.admin.password` when the operator supplies one.
  2. Otherwise, reuse the password already stored in the chart-managed
     admin Secret (so that reconciles do not rotate it).
  3. On the very first install with an empty value, generate a random
     20-character password.
*/}}
{{- define "gitea.adminPassword" -}}
{{- if .Values.admin.password -}}
{{- .Values.admin.password -}}
{{- else -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (printf "%s-admin" .Release.Name) -}}
{{- if and $existing (index $existing "data" | default dict | hasKey "password") -}}
{{- index $existing.data "password" | b64dec -}}
{{- else -}}
{{- randAlphaNum 20 -}}
{{- end -}}
{{- end -}}
{{- end -}}
