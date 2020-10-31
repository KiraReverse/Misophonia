using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpriteLayerController : MonoBehaviour {
    
	// Use this for initialization
	void Start ()
    {
	}

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if(collision.gameObject.tag == "Player")
        {
            GetComponent<SpriteRenderer>().sortingOrder = 6;
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            GetComponent<SpriteRenderer>().sortingOrder = 4;
        }
    }
}
