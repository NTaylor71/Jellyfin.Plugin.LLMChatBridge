#pragma warning disable CA1056 // URI-like properties should not be strings

using MediaBrowser.Model.Plugins;

namespace Jellyfin.Plugin.LLMChatBridge.Configuration;

/// <summary>
/// The plugin configuration for LLM Chat Bridge.
/// </summary>
public class PluginConfiguration : BasePluginConfiguration
{
    /// <summary>
    /// Gets or sets the primary LLM URL.
    /// </summary>
    public string PrimaryUrl { get; set; } = "http://192.X.X.X:11434";

    /// <summary>
    /// Gets or sets the primary model name.
    /// </summary>
    public string PrimaryModel { get; set; } = "llama3.2:3b";

    /// <summary>
    /// Gets or sets the system prompt for the primary model.
    /// </summary>
    public string PrimarySystemPrompt { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the secondary LLM URL.
    /// </summary>
    public string SecondaryUrl { get; set; } = "http://localhost:11435";

    /// <summary>
    /// Gets or sets the secondary model name.
    /// </summary>
    public string SecondaryModel { get; set; } = "llama3.2:1b";

    /// <summary>
    /// Gets or sets the system prompt for the secondary model.
    /// </summary>
    public string SecondarySystemPrompt { get; set; } = string.Empty;

    /// <summary>
    /// Gets or sets the request timeout in milliseconds.
    /// </summary>
    public int TimeoutMs { get; set; } = 3000;
}

#pragma warning restore CA1056
