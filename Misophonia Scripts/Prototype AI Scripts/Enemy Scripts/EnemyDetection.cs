using System;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyDetection : MonoBehaviour
{
    StateController stateCon;
    ChaseState chaseState;

    public LayerMask layerM;

    bool blink;
    public bool playerInSight;

    private void Start()
    {
        stateCon = GetComponentInParent<StateController>();
        chaseState = GetComponentInParent<ChaseState>();
        blink = false;
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {

        if (collision.gameObject.tag == "Player" && (stateCon.CurrState != StateController.State.stun && stateCon.CurrState != StateController.State.wait))
        {

            //if (isColliding) return;
            //isColliding = true;
            Vector3 dir = (collision.transform.position - transform.position).normalized;



            //RaycastHit2D hit = Physics2D.Raycast(transform.position, dir, 10f, layerM);

            RaycastHit2D[] hits = Physics2D.RaycastAll(transform.position, dir, 10f, layerM);
            Debug.DrawRay(transform.position, dir * 10f, Color.red, 1f, false);

            if (hits.Length > 0)
            {
                List<RaycastHit2D> hitList = new List<RaycastHit2D>(hits);

                hitList.Sort((y, x) => y.distance.CompareTo(x.distance));

                //hitList.Reverse();

                foreach (RaycastHit2D h in hitList)
                {
                    if ((h.collider != null) && (h.collider.gameObject.tag == "Wall") && !h.collider.isTrigger)
                    {
                        chaseState.SetIsInSight(false);
                        blink = true;
                        playerInSight = false;
                        break;
                    }

                    else if ((h.collider != null) && (h.collider.gameObject.tag == "Detect"))
                    {
                        chaseState.SetIsInSight(true);

                        if (stateCon.CurrState != StateController.State.chase)
                        {
                            playerInSight = true;
                        }
                        return;
                    }
                }
            }


        }
    }

    private void OnTriggerStay2D(Collider2D collision)
    {
        //if (collision.gameObject.tag == "Player" && stateCon.CurrState != StateController.State.stun && stateCon.CurrState != StateController.State.wait)
        //{
        //    Vector3 dir = (collision.transform.position - transform.position).normalized;

        //    //if(!chaseState.GetIsInSight())
        //    { 
        //    Debug.DrawRay(transform.position, dir * 10f, Color.red, 1f, false);

        //    //RaycastHit2D hit = Physics2D.Raycast(transform.position, dir, 10f, layerM);

        //    RaycastHit2D[] hits = Physics2D.RaycastAll(transform.position, dir, 10f, layerM);

        //        if (hits.Length > 0)
        //        {
        //            List<RaycastHit2D> hitList = new List<RaycastHit2D>(hits);

        //            hitList.Sort((x, y) => y.distance.CompareTo(x.distance));

        //            //hitList.Reverse();

        //            foreach (RaycastHit2D h in hitList)
        //            {
        //                if ((h.collider != null) && (h.collider.gameObject.tag == "Wall") && !h.collider.isTrigger)
        //                {
        //                    chaseState.SetIsInSight(false);
        //                    blink = true;
        //                    break;
        //                }

        //                else if ((h.collider != null) && (h.collider.gameObject.tag == "Detect"))
        //                {

        //                    if (blink)
        //                    {
        //                        blink = false;
        //                        GetComponent<Collider2D>().enabled = false;
        //                        GetComponent<Collider2D>().enabled = true;

        //                        break;
        //                    }
        //                }
        //            }
        //        }

        //        else
        //        {
        //            chaseState.SetIsInSight(false);
        //            blink = true;
        //        }
        //    }
        //}

        if ((collision.gameObject.tag == "Player" || collision.gameObject.tag == "Detect") && (stateCon.CurrState != StateController.State.stun && stateCon.CurrState != StateController.State.wait))
        {
            RaycastHit2D[] hits = Physics2D.LinecastAll(transform.position, collision.gameObject.transform.position, layerM);

            Debug.DrawLine(transform.position, collision.gameObject.transform.position, Color.red);

            if (hits.Length > 0)
            {

                List<RaycastHit2D> hitList = new List<RaycastHit2D>(hits);

                hitList.Sort((y, x) => y.distance.CompareTo(x.distance));

                foreach (RaycastHit2D h in hitList)
                {
                    if ((h.collider != null) && (h.collider.gameObject.tag == "Wall") && !h.collider.isTrigger)
                    {
                        chaseState.SetIsInSight(false);
                        playerInSight = false;
                        break;
                    }

                    else if (h.collider != null && (h.collider.gameObject.tag == "Detect"))
                    {

                        chaseState.SetIsInSight(true);
                        blink = false;
                        playerInSight = true;
                    }
                }
            }

            else
            {
                chaseState.SetIsInSight(false);
                blink = true;
            }

        }
    }



    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
            chaseState.SetIsInSight(false);

        }

    }

    private void Update()
    {
        //UnityEngine.Debug.Log(enemyManager.CurrState);

        //Debug.Log(chaseState.GetIsInSight());


        if (playerInSight && (stateCon.CurrState != StateController.State.stun && stateCon.CurrState != StateController.State.wait))
        {
            playerInSight = false;

            if (stateCon.CurrState != StateController.State.chase)
            {
                chaseState.ChaseInterrupt();
            }
        }
    }




}
