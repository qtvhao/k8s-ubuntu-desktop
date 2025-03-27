import express from 'express';
import { spawn, ChildProcessWithoutNullStreams } from 'child_process';

class ProcessManager {
  private chromeProcess: ChildProcessWithoutNullStreams | null = null;

  constructor(private remoteDebuggingPort: number) {
    this.startChrome();
  }

  startChrome(): void {
    const args = [
      '--start-maximized',
      '--user-data-dir=/data',
      `--remote-debugging-port=${this.remoteDebuggingPort}`,
      '--disable-gpu',
      '--disable-dev-shm-usage',
      '--disable-software-rasterizer',
      '--disable-proxy-certificate-handler',
      '--no-sandbox',
      '--no-first-run',
      '--disable-features=PrivacySandboxSettings4',
      '--no-zygote',
      '--user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15',
      'http://example.com'
    ];

    this.chromeProcess = spawn('google-chrome-stable', args, {
      env: { ...process.env, DISPLAY: ':0' }
    });

    this.chromeProcess.stdout.on('data', (data) => {
      console.log(`[Chrome STDOUT]: ${data}`);
    });

    this.chromeProcess.stderr.on('data', (data) => {
      console.error(`[Chrome STDERR]: ${data}`);
    });

    this.chromeProcess.on('close', (code) => {
      console.log(`[Chrome exited with code ${code}]`);
    });
  }

  async stopChrome(): Promise<void> {
    if (this.chromeProcess) {
      const processToClose = this.chromeProcess;
      this.chromeProcess.kill();
      await new Promise<void>((resolve) => {
        processToClose.on('close', () => resolve());
      });
      this.chromeProcess = null;
    }
  }

  async restartChrome(): Promise<void> {
    console.log('Restarting Chrome process...');
    await this.stopChrome();

    // Optional delay to ensure process has terminated
    await new Promise((resolve) => setTimeout(resolve, 1000));

    this.startChrome();
  }
}

const app = express();
const port = process.env.PORT ? parseInt(process.env.PORT) : 3000;
const remoteDebuggingPort = process.env.REMOTE_DEBUGGING_PORT ? parseInt(process.env.REMOTE_DEBUGGING_PORT) : 21222;

const manager = new ProcessManager(remoteDebuggingPort);

app.post('/restart', async (req, res) => {
  try {
    await manager.restartChrome();
    res.status(200).send('Chrome restarted successfully');
  } catch (error) {
    console.error('Failed to restart Chrome:', error);
    res.status(500).send('Failed to restart Chrome');
  }
});

app.listen(port, () => {
  console.log(`ProcessManager API listening at http://localhost:${port}`);
});
