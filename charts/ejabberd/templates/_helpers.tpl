{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ejabberd.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ejabberd.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Return the proper eJabberd image name
*/}}
{{- define "ejabberd.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "ejabberd.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "ejabberd.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return podAnnotations
*/}}
{{- define "ejabberd.podAnnotations" -}}
{{- if .Values.podAnnotations -}}
{{ include "common.tplvalues.render" (dict "value" .Values.podAnnotations "context" $) }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account
*/}}
{{- define "ejabberd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "ejabberd.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the erlang secret.
*/}}
{{- define "ejabberd.secretErlangName" -}}
    {{- if .Values.auth.existingErlangSecret -}}
        {{- printf "%s" (tpl .Values.auth.existingErlangSecret $) -}}
    {{- else -}}
        {{- printf "%s" (include "ejabberd.fullname" .) -}}
    {{- end -}}
{{- end -}}


{{/*
Get the TLS secret.
*/}}
{{- define "ejabberd.tlsSecretName" -}}
    {{- if .Values.auth.tls.existingSecret -}}
        {{- printf "%s" (tpl .Values.auth.tls.existingSecret $) -}}
    {{- else -}}
        {{- printf "%s-certs" (include "ejabberd.fullname" .) -}}
    {{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "ejabberd.createTlsSecret" -}}
{{- if and .Values.auth.tls.enabled (not .Values.auth.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}
