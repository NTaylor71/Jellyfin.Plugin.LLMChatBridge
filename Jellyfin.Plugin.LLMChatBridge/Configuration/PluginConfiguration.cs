using System;
using MediaBrowser.Model.Plugins;

namespace Jellyfin.Plugin.LLMChatBridge.Configuration;

/// <summary>
/// The plugin configuration for LLM Chat Bridge.
/// </summary>
public class PluginConfiguration : BasePluginConfiguration
{
    // Primary LLM settings

    /// <summary>
    /// Gets or sets the primary LLM URL.
    /// </summary>
    public Uri PrimaryUrl { get; set; } = new Uri("http://localhost:11434");

    /// <summary>
    /// Gets or sets the primary model name.
    /// </summary>
    public string PrimaryModel { get; set; } = "llama3.2:latest";

    /// <summary>
    /// Gets or sets the system prompt for the primary model.
    /// </summary>
    public string PrimarySystemPrompt { get; set; } =
        "You are a media expert. You specialise in recommending Movies, TV, Music, Audiobooks, Books and Comics. Be friendly and helpful. Pay attention to user queries about titles, genres, tags, release dates/years, actors, directors and plots. Your personality is a Surfer Dude who happens to be a psychedelic Llama with a sly sense of humour. Try to be personal in your replies. Your replies are ideally a little chatty and bullet points lists of (film/tv/book/etc) suggestions.";

    // Secondary fallback LLM settings

    /// <summary>
    /// Gets or sets the secondary LLM URL.
    /// </summary>
    public Uri SecondaryUrl { get; set; } = new Uri("http://localhost:11435");

    /// <summary>
    /// Gets or sets the secondary model name.
    /// </summary>
    public string SecondaryModel { get; set; } = "mistral:instruct";

    /// <summary>
    /// Gets or sets the system prompt for the secondary model.
    /// </summary>
    public string SecondarySystemPrompt { get; set; } =
        "You are a helpful assistant. If the user asks about media, respond with useful suggestions and keep it short.";

    /// <summary>
    /// Gets or sets the request timeout in milliseconds.
    /// </summary>
    public int TimeoutMs { get; set; } = 3000;
}
