using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class JumpController : MonoBehaviour
{
    public GameObject self;
    public float curvePoint;
    public EnemySoundController enemySfx;

    bool jumpActive;

    GameObject player;

    Generic2DCamFollow cam;

    float count;

    Vector3 p0;
    Vector3 p1;
    Vector3 p2;

    Collider2D enemyCol;

    // Use this for initialization
    void Awake ()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        cam = Camera.main.GetComponent<Generic2DCamFollow>();
    }

    private void OnEnable()
    {
        enemyCol = GetComponentInParent<Collider2D>();
        jumpActive = false;
        enemySfx.PlayGrowlLong();

        

        count = 0f;

        p0 = self.transform.position;
        p2 = player.transform.position;
        p1 = p0 + (p2 - p0) / 2 + Vector3.up * curvePoint;

    }

    // Update is called once per frame
    void Update ()
    {
		if(count< 1f && jumpActive)
        {
            count += 1f * Time.deltaTime;

            Vector3 m1 = Vector3.Lerp(p0, p1, count);
            Vector3 m2 = Vector3.Lerp(p1, p2, count);

            self.transform.position = Vector3.Lerp(m1, m2, count);
        }

        if(self.transform.position == p2)
        {
            
            enemyCol.enabled = true;
            cam.Shake(4f,8);
            enemySfx.PlayLand();
            gameObject.SetActive(false);
        }
	}

    IEnumerator ActivateJump()
    {
        yield return new WaitForSeconds(3.5f);
        
        enemyCol.enabled = false;

        jumpActive = true;
    }

}
