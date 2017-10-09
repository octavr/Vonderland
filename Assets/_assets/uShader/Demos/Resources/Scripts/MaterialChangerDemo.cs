using UnityEngine;
using System.Collections;

[System.Serializable]
[ExecuteInEditMode]
public class MaterialChangerDemo : MonoBehaviour {

    public Material[] materials = new Material[0];
    public int current = -1;

    bool change = true;
    bool firstTime = true;
	
	// Update is called once per frame
	void Update () {

        if (change)
            StartCoroutine(Timer());
	}
    IEnumerator Timer()
    {
        change = false;
        if(firstTime)
            yield return new WaitForSeconds(4.5f);
        else
            yield return new WaitForSeconds(9.0f);
        firstTime = false;
        change = true;
        if (materials.Length > 0)
        {
            current++;
            if (current >= materials.Length)
                current = 0;
            GetComponent<MeshRenderer>().material = materials[current];
        }
    }
}
