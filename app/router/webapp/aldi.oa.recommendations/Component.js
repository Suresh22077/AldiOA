sap.ui.define([
  "sap/fe/core/AppComponent"
], function(AppComponent) {
  "use strict";
  return AppComponent.extend("aldi.oa.recommendations", {
    metadata: {
      interfaces: ["sap.ui.core.IAsyncContentCreation"],
      manifest: "json"
    }
  });
});
