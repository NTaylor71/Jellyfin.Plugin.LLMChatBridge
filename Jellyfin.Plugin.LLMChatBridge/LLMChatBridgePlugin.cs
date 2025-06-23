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

    /// <inheritdoc/>
    public override string Name => "LLMChatBridge";

    /// <inheritdoc/>
    public override Guid Id => Guid.Parse("2e1cf23a-e3b3-45b2-a385-50749ff90352");

    /// <inheritdoc/>
    public override string Description =>
        "Routes chat prompts to local LLMs with model fallback and customizable system prompts.";

    /// <summary>
    /// Initializes a new instance of the <see cref="LLMChatBridgePlugin"/> class.
    /// </summary>
    /// <param name="applicationPaths">App paths provided by Jellyfin host.</param>
    /// <param name="xmlSerializer">XML serializer for config IO.</param>
    public LLMChatBridgePlugin(IApplicationPaths applicationPaths, IXmlSerializer xmlSerializer)
        : base(applicationPaths, xmlSerializer)
    {
        Instance = this;

        ConfigurationChanged += (_, _) =>
        {
            // Future: ChatRouter.Instance?.ConfigurationChanged(Configuration);
        };

        // Future: ChatRouter.Instance?.ConfigurationChanged(Configuration);
    }

    /// <inheritdoc/>
    public IEnumerable<PluginPageInfo> GetPages()
    {
        return new[]
        {
            new PluginPageInfo
            {
                Name = "llmchatbridge",
                EmbeddedResourcePath = GetType().Namespace + ".Web.llmchatbridge.html"
            }
        };
    }
}
