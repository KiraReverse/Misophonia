using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChargeController : MonoBehaviour
{
    public EnemySoundController enemySfx;

    public float chargeForce;
    public float dragVal;

    Rigidbody2D rgbd;

    private void OnEnable()
    {
        rgbd = GetComponentInParent<Rigidbody2D>();

        rgbd.drag = dragVal;

        enemySfx.PlayGrowl();

        StartCoroutine(Disable());

    }

    // Update is called once per frame
    void Update ()
    {
	}

    IEnumerator Disable()
    {
        yield return new WaitForSeconds(1.5f);
        rgbd.AddRelativeForce(Vector3.down * chargeForce, ForceMode2D.Force);
        yield return new WaitForSeconds(2f);
        //Debug.Log("turned off");
        gameObject.SetActive(false);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    { 
        if(collision.gameObject.tag == "Wall" && !collision.isTrigger)
        {
            gameObject.GetComponentInParent<StunState>().StunInterrupt();
            rgbd.velocity = Vector2.zero;
        }

       

        if(collision.gameObject.tag == "Player")
        {
            collision.gameObject.GetComponent<Rigidbody2D>().velocity = Vector2.zero;
            rgbd.velocity = Vector2.zero;
            collision.gameObject.GetComponent<Struggle>().BeginStruggle();

            GetComponentInParent<StateController>().CurrState = StateController.State.wait;
        }
    }

    private void OnDisable()
    {
        rgbd.velocity = Vector2.zero;
    }
}
