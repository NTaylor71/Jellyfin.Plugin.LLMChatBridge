using System;
using System.Collections.Generic;
using Jellyfin.Plugin.LLMChatBridge.Configuration;
using MediaBrowser.Common.Configuration;
using MediaBrowser.Common.Plugins;
using MediaBrowser.Model.Plugins;
using MediaBrowser.Model.Serialization;

namespace Jellyfin.Plugin.LLMChatBridge;

/// <summary>
/// The LLM Chat Bridge plugin.
/// </summary>
public class LLMChatBridgePlugin : BasePlugin<PluginConfiguration>, IHasWebPages
{
    /// <summary>
    /// Gets the plugin instance.
    /// </summary>
    public static LLMChatBridgePlugin? Instance { get; private set; }

    /// <summary>
    /// Gets the name of the plugin.
    /// </summary>
    public override string Name => "LLMChatBridge";

    /// <summary>
    /// Gets the unique ID for this plugin instance.
    /// </summary>
    public override Guid Id => Guid.Parse("2e1cf23a-e3b3-45b2-a385-50749ff90352");

    /// <summary>
    /// Gets the description shown in the Jellyfin plugin catalog.
    /// </summary>
    public override string Description =>
        "Routes chat prompts to local LLMs with model fallback and customizable system prompts.";

    /// <summary>
    /// Initializes a new instance of the <see cref="LLMChatBridgePlugin"/> class.
    /// </summary>
    /// <param name="applicationPaths">The application path manager provided by Jellyfin.</param>
    /// <param name="xmlSerializer">The XML serializer used for plugin configuration persistence.</param>
    public LLMChatBridgePlugin(IApplicationPaths applicationPaths, IXmlSerializer xmlSerializer)
        : base(applicationPaths, xmlSerializer)
    {
        Instance = this;

        ConfigurationChanged += (_, _) =>
        {
            // Future: ChatRouter.Instance?.ConfigurationChanged(Configuration);
        };
    }

    /// <summary>
    /// Gets the configuration pages used by this plugin, including the HTML UI and JS controller.
    /// </summary>
    /// <returns>A collection of plugin page info definitions.</returns>
    public IEnumerable<PluginPageInfo> GetPages()
    {
        return new[]
        {
            new PluginPageInfo
            {
                Name = "llmchatbridge",
                EmbeddedResourcePath = $"{GetType().Namespace}.Web.llmchatbridge.html"
            },
            new PluginPageInfo
            {
                Name = "llmchatbridgejs",
                EmbeddedResourcePath = $"{GetType().Namespace}.Web.llmchatbridge.js"
            }
        };
    }
}
