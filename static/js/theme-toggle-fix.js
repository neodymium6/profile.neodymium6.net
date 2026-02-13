(function () {
  var storageKey = "pref-theme";
  var html = document.documentElement;

  function getStoredTheme() {
    try {
      return localStorage.getItem(storageKey);
    } catch (e) {
      return null;
    }
  }

  function setStoredTheme(theme) {
    try {
      localStorage.setItem(storageKey, theme);
    } catch (e) {
      // Ignore storage errors (private mode, blocked storage, etc.).
    }
  }

  function prefersDark() {
    return (
      typeof window.matchMedia === "function" &&
      window.matchMedia("(prefers-color-scheme: dark)").matches
    );
  }

  function applyTheme(theme) {
    if (theme === "dark" || theme === "light") {
      html.dataset.theme = theme;
      return;
    }
    html.dataset.theme = prefersDark() ? "dark" : "light";
  }

  // Fallback for environments where inline scripts do not run.
  if (html.dataset.theme === "auto") {
    applyTheme(getStoredTheme() || "auto");
  } else {
    applyTheme(getStoredTheme() || html.dataset.theme);
  }

  function bindToggle() {
    var button = document.getElementById("theme-toggle");
    if (!button || button.dataset.themeFixBound === "1") {
      return;
    }
    button.dataset.themeFixBound = "1";

    // Capture phase to avoid duplicate toggles if theme scripts are doubled.
    button.addEventListener(
      "click",
      function (event) {
        event.preventDefault();
        event.stopImmediatePropagation();
        var next = html.dataset.theme === "dark" ? "light" : "dark";
        html.dataset.theme = next;
        setStoredTheme(next);
      },
      true
    );
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", bindToggle);
  } else {
    bindToggle();
  }

  if (typeof window.matchMedia === "function") {
    var media = window.matchMedia("(prefers-color-scheme: dark)");
    var onChange = function () {
      if (!getStoredTheme()) {
        applyTheme("auto");
      }
    };

    if (typeof media.addEventListener === "function") {
      media.addEventListener("change", onChange);
    } else if (typeof media.addListener === "function") {
      media.addListener(onChange);
    }
  }
})();
