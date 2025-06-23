using MediaBrowser.Controller;
using MediaBrowser.Controller.Plugins;
using Microsoft.Extensions.DependencyInjection;

namespace Jellyfin.Plugin.LLMChatBridge;

/// <summary>
/// Service registration stub for LLM Chat Bridge.
/// Leave this in place for future use (e.g., ChatRouter, HTTP clients).
/// </summary>
public class PluginServiceRegistrator : IPluginServiceRegistrator
{
    /// <summary>
    /// Registers any required services for this plugin.
    /// Currently unused but reserved for future feature expansion.
    /// </summary>
    /// <param name="serviceCollection">The Jellyfin DI service collection.</param>
    /// <param name="applicationHost">The Jellyfin application host.</param>
    public void RegisterServices(IServiceCollection serviceCollection, IServerApplicationHost applicationHost)
    {
        // Future:
        // serviceCollection.AddSingleton<ChatRouter>();
        // serviceCollection.AddHttpClient<OllamaClient>();
    }
}
