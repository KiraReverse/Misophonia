using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileController : MonoBehaviour
{
    public GameObject projectileSpawn;
    public GameObject projectileObj;
    public EnemySoundController enemySfx;
    GameObject player;
    public float throwTime; //put in throw animation time here

    public float projSpeed;
    public float projDrag;

	// Use this for initialization
	void Awake()
    {
        player = GameObject.FindGameObjectWithTag("Player");
    }

    private void OnEnable()
    {
        GameObject rock = Instantiate(projectileObj, projectileSpawn.transform.position, projectileSpawn.transform.rotation);
        enemySfx.PlayToss();
        Vector3 target = player.transform.position - transform.position;
        var newDir = Quaternion.LookRotation(target, Vector3.forward);
        newDir.x = 0;
        newDir.y = 0;
        rock.transform.rotation = newDir;

        rock.GetComponent<Rigidbody2D>().drag = projDrag;
        rock.GetComponent<Rigidbody2D>().AddRelativeForce(Vector3.down * projSpeed, ForceMode2D.Force);

        StartCoroutine(Disable());
    }

    IEnumerator Disable()
    {
        yield return new WaitForSeconds(throwTime);
        Debug.Log("turned off");
        gameObject.SetActive(false);
    }

    // Update is called once per frame
    void Update ()
    {
		
	}
}
