using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class realtimereflections : MonoBehaviour {

	public int cubemapSize = 128;
	public bool oneFacePerFrame = false;
	private Camera cam;
	private RenderTexture rtex;
	private GameObject go;

	[ExecuteInEditMode]
	void Start() {
		// render all six faces at startup
		UpdateCubemap(63);
	}

	void LateUpdate() {
		if (oneFacePerFrame) {
			int faceToRender = Time.frameCount % 6;
			int faceMask = 1 << faceToRender;
			UpdateCubemap(faceMask);
		} else {
			UpdateCubemap(63); // all six faces
		}
	}

	void UpdateCubemap(int faceMask) {
		if (!cam) {
			go = new GameObject("CubemapCamera");
			go.AddComponent(typeof(Camera));
			go.hideFlags = HideFlags.HideAndDontSave;
			go.transform.position = transform.position;
			go.transform.rotation = Quaternion.identity;
			cam = go.GetComponent<Camera>();
			cam.farClipPlane = 100; // don't render very far into cubemap
			cam.enabled = false;
		}

		if (!rtex) {    
			rtex = new RenderTexture(cubemapSize, cubemapSize, 16);
			rtex.isCubemap = true;
			rtex.hideFlags = HideFlags.HideAndDontSave;
			GetComponent<Renderer>().sharedMaterial.SetTexture ("_Cube", rtex);
		}

		cam.transform.position = transform.position;
		cam.RenderToCubemap(rtex, faceMask);
	}

	void OnDisable() {
		DestroyImmediate (cam);
		DestroyImmediate (rtex);
	}
}