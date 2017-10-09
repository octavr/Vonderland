using UnityEngine;
using System.Collections;

public class SIG_demo_GUI : MonoBehaviour {

	public ShaderIndependentGlow sig;

	const int height = 160;
	const int width = 350;

	void OnGUI () 
	{
		GUI.Label(new Rect(Screen.width-170,0,170,20),"Shader-Independent Glow Demo");
		sig.enabled = GUI.Toggle(new Rect(Screen.width-100,20,100,20),sig.enabled,"SIG enabled");
		GUILayout.BeginArea(new Rect (0,Screen.height - height,width,height));
		GUILayout.BeginVertical("box");
		GUILayout.BeginHorizontal();
		Color col = GUI.backgroundColor;
		GUI.color = sig.globalGlowTint;
		GUILayout.Label("Global tint:");
		GUI.color = col;
		GUILayout.Label(" R:");
		sig.globalGlowTint.r = GUILayout.HorizontalSlider(sig.globalGlowTint.r,0,1.0f,GUILayout.Width(60));
		GUILayout.Label(" G:");
		sig.globalGlowTint.g = GUILayout.HorizontalSlider(sig.globalGlowTint.g,0,1.0f,GUILayout.Width(60));
		GUILayout.Label(" B:");
		sig.globalGlowTint.b = GUILayout.HorizontalSlider(sig.globalGlowTint.b,0,1.0f,GUILayout.Width(60));
		GUILayout.EndHorizontal();

		GUILayout.BeginHorizontal();
		GUILayout.Label("No-blur power:");
		sig.mainPower = GUILayout.HorizontalSlider(sig.mainPower,-2.0f,2.0f,GUILayout.Width(150));
		GUILayout.EndHorizontal();

		GUILayout.BeginHorizontal();
		GUILayout.Label("Blur power:");
		sig.blurPower = GUILayout.HorizontalSlider(sig.blurPower,-2.0f,3.0f,GUILayout.Width(150));
		GUILayout.EndHorizontal();

		GUILayout.BeginHorizontal();
		GUILayout.Label("Blur downsample:");
		sig.blurDownsample = (int)GUILayout.HorizontalSlider(sig.blurDownsample,0,3,GUILayout.Width(150));
		GUILayout.EndHorizontal();

		GUILayout.BeginHorizontal();
		GUILayout.Label("Blur size:");
		sig.blurSize = GUILayout.HorizontalSlider(sig.blurSize,0.0f,8.0f,GUILayout.Width(150));
		GUILayout.EndHorizontal();

		GUILayout.BeginHorizontal();
		GUILayout.Label("Blur iterations:");
		sig.blurIterations = (int)GUILayout.HorizontalSlider(sig.blurIterations,0,5,GUILayout.Width(150));
		GUILayout.EndHorizontal();


		/*
		GUILayout.BeginHorizontal();
		GUILayout.Label("Background:");
		sts.backgroundRenderType = (SeeThroughSystem.BackgroundRender)(GUILayout.SelectionGrid((int)sts.backgroundRenderType,backgrounds,1,"toggle",GUILayout.Width(150)));
		GUILayout.EndHorizontal();
		GUILayout.Label("",GUILayout.Height(7));
		GUILayout.BeginHorizontal();
		if (sts.colorizeTriggers = GUILayout.Toggle(sts.colorizeTriggers,"Colorize triggers"))
			sts.colorStrength = GUILayout.HorizontalSlider(sts.colorStrength,0,1.0f,GUILayout.Width(150));
		GUILayout.EndHorizontal();
		GUILayout.BeginHorizontal();
		GUILayout.Label("Transparency:");
		sts.transparency = GUILayout.HorizontalSlider(sts.transparency,0,1.0f,GUILayout.Width(150));
		GUILayout.EndHorizontal();
		GUILayout.BeginHorizontal();
		GUILayout.Label("Sensitivity:");
		sts.sensitivity = GUILayout.HorizontalSlider(sts.sensitivity,-0.3f,0.3f,GUILayout.Width(150));
		GUILayout.EndHorizontal();
		GUILayout.BeginHorizontal();
		Color col = GUI.backgroundColor;
		GUI.color = sts.tintColor;
		GUILayout.Label("Tint","box");
		GUI.color = col;
		GUILayout.Label(" R:");
		sts.tintColor.r = GUILayout.HorizontalSlider(sts.tintColor.r,0,1.0f,GUILayout.Width(70));
		GUILayout.Label(" G:");
		sts.tintColor.g = GUILayout.HorizontalSlider(sts.tintColor.g,0,1.0f,GUILayout.Width(70));
		GUILayout.Label(" B:");
		sts.tintColor.b = GUILayout.HorizontalSlider(sts.tintColor.b,0,1.0f,GUILayout.Width(70));
		GUILayout.EndHorizontal();
		GUILayout.Label("",GUILayout.Height(7));
		if (sts.backgroundRenderType == SeeThroughSystem.BackgroundRender.hologram
		    || sts.backgroundRenderType == SeeThroughSystem.BackgroundRender.alpha_hologram
		    || sts.backgroundRenderType == SeeThroughSystem.BackgroundRender.outline)
		{
			GUILayout.BeginHorizontal();
			col = GUI.backgroundColor;
			GUI.color = sts.effectColor;
			GUILayout.Label("Effect","box");
			GUI.color = col;
			GUILayout.Label(" R:");
			sts.effectColor.r = GUILayout.HorizontalSlider(sts.effectColor.r,0,1.0f,GUILayout.Width(70));
			GUILayout.Label(" G:");
			sts.effectColor.g = GUILayout.HorizontalSlider(sts.effectColor.g,0,1.0f,GUILayout.Width(70));
			GUILayout.Label(" B:");
			sts.effectColor.b = GUILayout.HorizontalSlider(sts.effectColor.b,0,1.0f,GUILayout.Width(70));
			GUILayout.EndHorizontal();
		}
		*/
		GUILayout.EndVertical();
		GUILayout.EndArea();

		/*
		GUILayout.BeginArea(new Rect (width+1,Screen.height - height,width,height));
		GUILayout.BeginVertical("box");
		GUILayout.BeginHorizontal();
		GUILayout.Label("Blur spill:");
		sts.blurSpilling = GUILayout.HorizontalSlider(sts.blurSpilling,0,1.0f,GUILayout.Width(70));
		GUILayout.EndHorizontal();
		if (sts.hardBlur = GUILayout.Toggle(sts.hardBlur,"Area range"))
		{
			GUILayout.BeginHorizontal();
			GUILayout.Label("blur size:");
			sts.HBblurSize = GUILayout.HorizontalSlider(sts.HBblurSize,0,12.0f);
			GUILayout.EndHorizontal();
			GUILayout.BeginHorizontal();
			GUILayout.Label("iterations:");
			sts.HBblurIterations = (int)GUILayout.HorizontalSlider(sts.HBblurIterations,1,5);
			GUILayout.EndHorizontal();
		}
		if (sts.softBlur = GUILayout.Toggle(sts.softBlur,"Area blur"))
		{
			GUILayout.BeginHorizontal();
			GUILayout.Label("blur size:");
			sts.SBblurSize = GUILayout.HorizontalSlider(sts.SBblurSize,0,12.0f);
			GUILayout.EndHorizontal();
			GUILayout.BeginHorizontal();
			GUILayout.Label("iterations:");
			sts.SBblurIterations = (int)GUILayout.HorizontalSlider(sts.SBblurIterations,1,5);
			GUILayout.EndHorizontal();
		}

		GUILayout.EndVertical();


		GUILayout.EndArea();
		*/
	}



	// Use this for initialization
	void Start () 
	{
		sig.enabled = true;	
	}

}
