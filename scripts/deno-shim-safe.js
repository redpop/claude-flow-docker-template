// Safe Deno Shim for Node.js - doesn't interfere with console output
// This provides minimal Deno API compatibility for claude-flow@alpha

// Only load if not already loaded
if (typeof globalThis.Deno === 'undefined') {
  globalThis.Deno = {
    // Working directory
    cwd: () => process.cwd(),
    
    // Environment variables
    env: {
      get: (key) => process.env[key],
      set: (key, value) => { process.env[key] = value; },
      delete: (key) => { delete process.env[key]; },
      toObject: () => ({ ...process.env })
    },
    
    // Version info
    version: {
      deno: "2.4.2-shim",
      v8: process.versions.v8,
      typescript: "5.4.5"
    },
    
    // Build info
    build: {
      target: process.platform,
      arch: process.arch,
      os: process.platform,
      vendor: "node-shim",
      env: process.env.NODE_ENV || "production"
    },
    
    // Exit
    exit: (code = 0) => process.exit(code),
    
    // Permissions (stub - always grant)
    permissions: {
      query: () => Promise.resolve({ state: "granted" }),
      request: () => Promise.resolve({ state: "granted" }),
      revoke: () => Promise.resolve({ state: "denied" })
    },
    
    // Basic Command stub - minimal implementation
    Command: class {
      constructor(cmd, options = {}) {
        this.cmd = cmd;
        this.options = options;
      }
      
      output() {
        // Return minimal success response
        return Promise.resolve({
          code: 0,
          success: true,
          stdout: new Uint8Array(),
          stderr: new Uint8Array()
        });
      }
      
      outputSync() {
        return {
          code: 0,
          success: true,
          stdout: new Uint8Array(),
          stderr: new Uint8Array()
        };
      }
    }
  };
}