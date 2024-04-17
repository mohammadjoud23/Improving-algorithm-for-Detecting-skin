using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;



namespace test
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
     
        OpenFileDialog file = new OpenFileDialog();
      
        Bitmap image;
        string filename;

          string[] X = new string[] { "", "", "" };



        private void button2_Click_1(object sender, System.EventArgs e)
        {
         

        }




        private void button1_Click(object sender, System.EventArgs e)
        {

            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.ShowDialog();


                filename = ofd.FileName;
                image = new Bitmap(filename);
                pictureBox2.Image = image;
            

            }


            catch (Exception)
            {


            }



            try
            {



                // Create the MATLAB instance 
                MLApp.MLApp matlab = new MLApp.MLApp();


                matlab.Execute(@"cd C:\Users\Naddaf\Desktop\Graduation");

                // Define the output 
                object result = null;
               
            
                // Call the MATLAB function myfunc
                matlab.Feval("cancer", 1, out result, filename);

                // Display result 
                object[] res = result as object[];

                textBox1.Text = res[0].ToString();




            }
            catch (Exception)
            {

                MessageBox.Show("no con");
            }



        }

      



        private void button3_Click(object sender, System.EventArgs e)
        {
            this.Close();
        }




        private void timer1_Tick(object sender, System.EventArgs e)
        {
           
        }

        private void button4_Click(object sender, System.EventArgs e)
        {
            
        }

        private void button4_Click_1(object sender, System.EventArgs e)
        {
           
        }

        private void button2_Click(object sender, EventArgs e)
        {
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click_2(object sender, EventArgs e)
        {
            if (X[0] == "")
            {
                MessageBox.Show("no data");


            }
            else
            {

                richTextBox1.Clear();
                string fn = "C:/Users/Naddaf/Desktop/Graduation/data - Copy.txt";
                int nx = 3;  // Number predictor variables
                int nc = 2;  // Number classes
                int N = 15;  // Number data items
                string[][] data = LoadData(fn, N, nx + 1, ',');



                int[][] jointCts = MatrixInt(nx, nc);
                int[] yCts = new int[nc];



                for (int i = 0; i < N; ++i)
                {
                    int y = int.Parse(data[i][nx]);
                    ++yCts[y];
                    for (int j = 0; j < nx; ++j)
                    {
                        if (data[i][j] == X[j])
                            ++jointCts[j][y];
                    }
                }
                // Laplacian smoothing
                for (int i = 0; i < nx; ++i)
                    for (int j = 0; j < nc; ++j)
                        ++jointCts[i][j];




                // Compute evidence terms
                double[] eTerms = new double[nc];
                for (int k = 0; k < nc; ++k)
                {
                    double v = 1;
                    for (int j = 0; j < nx; ++j)
                    {
                        v *= (double)(jointCts[j][k]) / (yCts[k] + nx);
                    }
                    v *= (double)(yCts[k]) / N;
                    eTerms[k] = v;
                }



                double evidence = 0;
                for (int k = 0; k < nc; ++k)
                    evidence += eTerms[k];
                double[] probs = new double[nc];
                for (int k = 0; k < nc; ++k)
                 probs[k] = eTerms[k] / evidence;

                // richTextBox1.AppendText("Probabilities: ");
                // for (int k = 0; k < nc; ++k)
                //   richTextBox1.AppendText( probs[k].ToString("F4") + "     ");
                //richTextBox1.AppendText("\n");
                richTextBox1.AppendText("Probabilities: % ");

                for (int k = 0; k < nc; ++k)
                    richTextBox1.AppendText((probs[k]* 100) + "  \n ");
                //richTextBox1.AppendText(((Math.Truncate( probs[k]* 100))) + "  \n ");
                richTextBox1.AppendText("\n");


                int pc = ArgMax(probs);
                richTextBox1.AppendText("Predicted class: ");
                richTextBox1.AppendText(pc.ToString());
                if (pc == 0)
                {
                    richTextBox1.AppendText("\n");
                    richTextBox1.AppendText("flu");
                }
                if (pc == 1)
                {
                    richTextBox1.AppendText("\n");
                    richTextBox1.AppendText("corona ");
                }
                for(int t=0;t<3;t++)
                {
                    X[t] = "";


                }
            }
              
            } 
            static string[][] MatrixString(int rows, int cols)
            {
                string[][] result = new string[rows][];
                for (int i = 0; i < rows; ++i)
                    result[i] = new string[cols];
                return result;
            }
            static int[][] MatrixInt(int rows, int cols)
            {
                int[][] result = new int[rows][];
                for (int i = 0; i < rows; ++i)
                    result[i] = new int[cols];
                return result;
            }
            static string[][] LoadData(string fn, int rows,int cols, char delimit)
            {
                string[][] result = MatrixString(rows, cols);
                FileStream ifs = new FileStream(fn, FileMode.Open);
                StreamReader sr = new StreamReader(ifs);
                string[] tokens = null;
                string line = null;
                int i = 0;
                while ((line = sr.ReadLine()) != null)
                {
                    tokens = line.Split(delimit);
                   
                    for (int j = 0; j < cols; ++j)
                        result[i][j] = tokens[j];
                    
                    ++i;
                }
                sr.Close(); ifs.Close();
                return result;
            }
            static int ArgMax(double[] vector)
            {
                int result = 0;
                double maxV = vector[0];
                for (int i = 0; i < vector.Length; ++i)
                {
                    if (vector[i] > maxV)
                    {
                        maxV = vector[i];
                        result = i;
                    }
                }
                return result;
            }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            X[0]="A";
        }

        private void checkBox8_CheckedChanged(object sender, EventArgs e)
        {
         X[0]="a";
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
             X[1]="B";
        }

        private void checkBox7_CheckedChanged(object sender, EventArgs e)
        {
             X[1]="b";
        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {
             X[2]="C";
        }

        private void checkBox6_CheckedChanged(object sender, EventArgs e)
        {
             X[2]="c";
        }

        private void checkBox4_CheckedChanged(object sender, EventArgs e)
        {
             X[2]="D";
        }

        private void checkBox5_CheckedChanged(object sender, EventArgs e)
        {
             X[2]="d";
        }

        private void button4_Click_2(object sender, EventArgs e)
        {
            try
            {
                OpenFileDialog ofd = new OpenFileDialog();
                ofd.ShowDialog();


                filename = ofd.FileName;
                image = new Bitmap(filename);
                pictureBox1.Image = image;


            }


            catch (Exception)
            {


            }



            try
            {



                // Create the MATLAB instance 
                MLApp.MLApp matlab = new MLApp.MLApp();


                matlab.Execute(@"cd C:\Users\Naddaf\Desktop\Graduation");

                // Define the output 
                object result = null;


                // Call the MATLAB function myfunc
                matlab.Feval("age", 1, out result, filename);

                // Display result 
                object[] res = result as object[];

                textBox2.Text = res[0].ToString();




            }
            catch (Exception)
            {

                MessageBox.Show("no con");
            }



        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void textBox2_TextChanged(object sender, EventArgs e)
        {

        }

        private void label7_Click(object sender, EventArgs e)
        {

        }

        private void groupBox3_Enter(object sender, EventArgs e)
        {

        }
        }






    }




        
    

