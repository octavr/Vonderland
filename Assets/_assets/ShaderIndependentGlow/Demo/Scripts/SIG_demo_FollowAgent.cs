using UnityEngine;
using System.Collections;

public class SIG_demo_FollowAgent : MonoBehaviour {

	public Transform agent;


	// Update is called once per frame
	void Update () 
	{
		GetComponent<Camera>().transform.LookAt(agent);
	}
}
