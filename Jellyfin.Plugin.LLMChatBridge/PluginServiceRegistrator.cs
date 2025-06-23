using MediaBrowser.Controller;
using MediaBrowser.Controller.Plugins;
using Microsoft.Extensions.DependencyInjection;

namespace Jellyfin.Plugin.LLMChatBridge;

/// <summary>
/// Registers services for the LLM Chat Bridge plugin.
/// </summary>
public class PluginServiceRegistrator : IPluginServiceRegistrator
{
    /// <inheritdoc/>
    public void RegisterServices(IServiceCollection serviceCollection, IServerApplicationHost applicationHost)
    {
        // serviceCollection.AddSingleton<ChatRouter>(); // Replace with actual class once defined
    }
}
