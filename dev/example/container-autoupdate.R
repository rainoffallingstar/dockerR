dockerR::container_update(containerid = "lobe-chat",
                          imageid = "lobehub/lobe-chat",
                          force_rm_container = FALSE,
                          volume = NULL,
                          ports = "-p 3210:3210",
                          environmentvarible = "-e OPENAI_API_KEY=sk-97sVg41KF1zHyqrlB0C892BfC4824d8cA64cFaE15b312fE7 -e OPENAI_PROXY_URL=https://api.aigcapi.io/v1 -e ACCESS_CODE=fallingstar -e OLLAMA_PROXY_URL=http://host.docker.internal:11434/v1",
                          ifD = TRUE,
                          restart = TRUE,
                          run_at_once = TRUE)
