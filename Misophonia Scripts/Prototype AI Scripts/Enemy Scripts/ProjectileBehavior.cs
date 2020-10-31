using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileBehavior : MonoBehaviour
{
    public float lifetime;

	// Use this for initialization
	void Start ()
    {
        Destroy(gameObject, lifetime);
	}

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.gameObject.tag == "Player")
        {
            collision.gameObject.GetComponent<Struggle>().SlowDown();
            Destroy(gameObject);
        }
    }
}
