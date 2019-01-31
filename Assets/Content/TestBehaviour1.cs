using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading.Tasks;

public class TestBehaviour1 : MonoBehaviour {

	// Use this for initialization
	async Task Start () {
		await Task.Delay(3000);
		Debug.Log("Finished start");
	}
	
	// Update is called once per frame
	void Update () {
		Debug.Log("Running Update");
	}
}
