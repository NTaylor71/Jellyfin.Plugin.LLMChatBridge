console.log("[LLMChatBridge] controller loaded");

const LLMChatBridgeConfig = {
    pluginUniqueId: "2e1cf23a-e3b3-45b2-a385-50749ff90352",
    defaultPrompt: `You are a media expert. You specialise in recommending Movies, TV, Music, Audiobooks, Books and Comics. Be friendly and helpful. Pay attention to user queries about titles, genres, tags, release dates/years, actors, directors and plots. Your personality is a Surfer Dude who happens to be a psychedelic Llama with a sly sense of humour. Try to be personal in your replies. Your replies are ideally a little chatty and bullet point lists of (film/tv/book/etc) suggestions.`,

    defaultConfig: {
        PrimaryUrl: "http://192.X.X.X:11434",
        PrimaryModel: "llama3.2:3b",
        PrimarySystemPrompt: null,
        SecondaryUrl: "http://localhost:11435",
        SecondaryModel: "llama3.2:1b",
        SecondarySystemPrompt: null,
        TimeoutMs: 3000
    }
};

export default function(view, params) {
    view.addEventListener('viewshow', function () {
        Dashboard.showLoadingMsg();
        const form = view.querySelector("#LLMChatBridgeConfigForm");

        ApiClient.getPluginConfiguration(LLMChatBridgeConfig.pluginUniqueId).then(config => {
            // Apply saved config, or fallback to defaults
            form.querySelector("#PrimaryUrl").value =
                config.PrimaryUrl || LLMChatBridgeConfig.defaultConfig.PrimaryUrl;

            console.log("PrimaryModel raw:", config.PrimaryModel);

            form.querySelector("#PrimaryModel").value =
                config.PrimaryModel || LLMChatBridgeConfig.defaultConfig.PrimaryModel;

            form.querySelector("#PrimarySystemPrompt").value =
                config.PrimarySystemPrompt || LLMChatBridgeConfig.defaultPrompt;

            form.querySelector("#SecondaryUrl").value =
                config.SecondaryUrl || LLMChatBridgeConfig.defaultConfig.SecondaryUrl;

            form.querySelector("#SecondaryModel").value =
                config.SecondaryModel || LLMChatBridgeConfig.defaultConfig.SecondaryModel;

            form.querySelector("#SecondarySystemPrompt").value =
                config.SecondarySystemPrompt || LLMChatBridgeConfig.defaultPrompt;

            form.querySelector("#TimeoutMs").value =
                config.TimeoutMs != null ? config.TimeoutMs : LLMChatBridgeConfig.defaultConfig.TimeoutMs;

            Dashboard.hideLoadingMsg();
            console.log("[LLMChatBridge] config loaded", config);
        }).catch(() => {
            Dashboard.hideLoadingMsg();
            Dashboard.processErrorResponse({
                statusText: "Failed to load plugin configuration"
            });
        });
    });

    view.querySelector("#LLMChatBridgeConfigForm").addEventListener("submit", function (e) {
        e.preventDefault();

        const form = this;
        const saveButton = form.querySelector("#save-button");
        saveButton.disabled = true;
        Dashboard.showLoadingMsg();

        const config = {
            PrimaryUrl: form.querySelector("#PrimaryUrl").value.trim(),
            PrimaryModel: form.querySelector("#PrimaryModel").value.trim(),
            PrimarySystemPrompt: form.querySelector("#PrimarySystemPrompt").value.trim(),
            SecondaryUrl: form.querySelector("#SecondaryUrl").value.trim(),
            SecondaryModel: form.querySelector("#SecondaryModel").value.trim(),
            SecondarySystemPrompt: form.querySelector("#SecondarySystemPrompt").value.trim(),
            TimeoutMs: parseInt(form.querySelector("#TimeoutMs").value.trim()) || LLMChatBridgeConfig.defaultConfig.TimeoutMs
        };

        ApiClient.updatePluginConfiguration(LLMChatBridgeConfig.pluginUniqueId, config).then(result => {
            Dashboard.hideLoadingMsg();
            Dashboard.processPluginConfigurationUpdateResult(result);
            saveButton.disabled = false;
        }).catch(() => {
            Dashboard.hideLoadingMsg();
            Dashboard.processErrorResponse({ statusText: "Failed to update plugin configuration" });
            saveButton.disabled = false;
        });
    });
}
