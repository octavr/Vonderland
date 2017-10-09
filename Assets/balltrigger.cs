using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class balltrigger : MonoBehaviour {


	public Light light;
	public AudioSource flowersound;


	void OnTriggerEnter(Collider other) {
		light.enabled = true;
		flowersound.Play ();

	}
}
