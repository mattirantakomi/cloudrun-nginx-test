# Google Cloud Run SSH Shell access

Create Cloud Run Service
```
gcloud alpha run deploy cloudrun-nginx-test \
   --image mattirantakomi/cloudrun-nginx-test:latest \
   --update-env-vars TAILSCALE_AUTHKEY="<https://login.tailscale.com/admin/settings/keys, generate auth key>" \
   --allow-unauthenticated \
   --cpu 1 \
   --memory 512Mi \
   --min-instances 1 \
   --max-instances 1 \
   --execution-environment gen2 \
   --region europe-north1 \
   --project <your-project>
```

List tailscale machine IP's using `tailscale status` and enter cloudrun shell with `tailscale ssh ip` command.
