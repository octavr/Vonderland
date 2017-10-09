using UnityEngine;
using System.Collections;

[System.Serializable, ExecuteInEditMode]
public class ColorSpaceManager : MonoBehaviour {

    public ColorSpace colorSpace;

	// Use this for initialization
    void Awake()
    {
#if UNITY_EDITOR
        UnityEditor.PlayerSettings.colorSpace = colorSpace;
#endif
	}
}
