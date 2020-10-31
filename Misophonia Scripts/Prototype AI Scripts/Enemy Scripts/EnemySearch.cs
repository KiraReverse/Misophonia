using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySearch : MonoBehaviour
{
    List<GameObject> searchables;
    public LayerMask layerM;

	// Use this for initialization
	void Start ()
    {
        searchables = new List<GameObject>();
	}
	
	// Update is called once per frame
	void Update ()
    {
	}

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Locker")
        {
            Vector3 dir = (collision.transform.position - transform.position).normalized;

            //Debug.DrawRay(transform.position, dir * GetComponent<CircleCollider2D>().radius, Color.red, 10f, false);

            RaycastHit2D hit = Physics2D.Raycast(transform.position, dir, GetComponent<CircleCollider2D>().radius, layerM);

            

            if ((hit.collider != null) && (hit.collider.gameObject.tag == "Locker"))
            {
                searchables.Add(hit.collider.gameObject);
            }
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Locker")
        {
            if (searchables.Contains(collision.gameObject))
            {
                searchables.Remove(collision.gameObject);
            }
        }
    }

    public List<GameObject> GetSearchables()
    {
        return searchables;
    }
}
