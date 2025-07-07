using FarmingSimulatorSDKClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Fleck;

namespace FarmingSimulatorTelemetria.ALP
{
    public partial class FarmingSimulatorTelemetry : Form
    {
        private  FSTelemetryReader telemetryReader;
        private WebSocketServer wsServer;
        private List<IWebSocketConnection> wsClients = new List<IWebSocketConnection>();

        public FarmingSimulatorTelemetry()
        {
            InitializeComponent();
            StartTelemetry();



        }

        private void StartTelemetry()
        {
            telemetryReader = new FSTelemetryReader();
            telemetryReader.OnTelemetryRead += TelemetryReader_OnTelemetryRead;
            telemetryReader.Start();
            StartWebSocketServer();
        }

        private void StartWebSocketServer()
        {
            wsServer = new WebSocketServer("ws://0.0.0.0:8181");
            wsServer.Start(socket =>
            {
                socket.OnOpen = () =>
                {
                    wsClients.Add(socket);
                    Console.WriteLine("WebSocket client connected!");
                };
                socket.OnClose = () =>
                {
                    wsClients.Remove(socket);
                    Console.WriteLine("WebSocket client disconnected!");
                };
            });
        }

        private void StopWebSocketServer()
        {
            foreach (var client in wsClients.ToList())
            {
                client.Close();
            }
            wsClients.Clear();
            wsServer?.Dispose();
            wsServer = null;
        }

        private void TelemetryReader_OnTelemetryRead(FSTelemetry telemetry)
        {
            var texto = JsonConvert.SerializeObject(telemetry, Formatting.Indented);
           
            foreach (var client in wsClients.ToList())
            {
                if (client.IsAvailable)
                {
                    client.Send(texto);
                }
            }
        }

        private void buttonStart_Click(object sender, EventArgs e)
        {
            telemetryReader = new FSTelemetryReader();
            telemetryReader.OnTelemetryRead += TelemetryReader_OnTelemetryRead;
            telemetryReader.Start();
            StartWebSocketServer();
        }

        private void buttonStop_Click(object sender, EventArgs e)
        {
            telemetryReader?.Stop();
            StopWebSocketServer();
        }

        private void FarmingSimulatorTelemetry_FormClosed(object sender, FormClosedEventArgs e)
        {
            telemetryReader?.Stop();
            StopWebSocketServer();
        }
    }
}
