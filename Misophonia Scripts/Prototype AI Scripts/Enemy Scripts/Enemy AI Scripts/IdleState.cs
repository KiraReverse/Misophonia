using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class IdleState : BaseBehavior
{
    //Global Stats
    public StateController stateCon;

    public float moveSpeed;
    public float turnSpeed;
    public float distTolerance;
    public float rotSpeed;

    //Grid gridManager;
    GridManager gM;

    int dumbCounter;
    const int dumbCheck = 200;
    int stuckCounter;
    const int stuckCheck = 50;

    int nodeNum = 0;

    bool reached;

    List<GameObject> path;
    List<GameObject> waypoints;
    List<GameObject> visted;

    //Idle Stats
    Vector3 newIdlePos;

    public bool canIdle;
    public float cdIdle;

    //Audio
    public EnemySoundController enemySfx;


	// Use this for initialization
	void Awake ()
    {
        //gridManager = GameObject.FindGameObjectWithTag("GM").GetComponent<Grid>();

        gM = GameObject.FindGameObjectWithTag("GridManager").GetComponent<GridManager>();

        path = new List<GameObject>();
        waypoints = new List<GameObject>();
        visted = new List<GameObject>();

        reached = false;
        canIdle = true;

        dumbCounter = 0;
        stuckCounter = 0;

        foreach (GameObject wp in GameObject.FindGameObjectsWithTag("Waypoints"))
        {
            waypoints.Add(wp);
        }

    }
	
	// Update is called once per frame
	void Update ()
    {

     
	}

    public override void Enter()
    {
        ResetStats();
        canIdle = false;

        //IdlePath();
       

        stateCon.CurrState = StateController.State.idle;
    }

    public override void Exit()
    {

        stateCon.CurrState = StateController.State.ponderEnter;
    }

    public override void StateLoop()
    {

        StuckCheck();


        if (dumbCounter >= dumbCheck || path.Count == 0)
        {
            IdlePath();
        }

        if (reached)
        {
            StartCoroutine(CDIdle());
            stateCon.CurrState = StateController.State.idleExit;
            return;
        }

        if (path.Count > 0 && !reached)
        {

            
            //Vector3 target = new Vector3(gridManager.GridToWorld(path[nodeNum]).x, gridManager.GridToWorld(path[nodeNum]).y, 0) - transform.position;
            Vector3 target = path[nodeNum].transform.position - transform.position;
            var newDir = Quaternion.LookRotation(target, Vector3.forward);
            newDir.x = 0;
            newDir.y = 0;
            transform.rotation = Quaternion.Slerp(transform.rotation, newDir, Time.deltaTime * rotSpeed);
            //transform.position = Vector2.MoveTowards(transform.position, gridManager.GridToWorld(path[nodeNum]), moveSpeed * Time.deltaTime);
            transform.position = Vector2.MoveTowards(transform.position, path[nodeNum].transform.position, moveSpeed * Time.deltaTime);
            ++dumbCounter;

            enemySfx.PlayWalk();

            Vector2 currPos = transform.position;

            //float distA = Vector2.Distance(currPos, gridManager.GridToWorld(path[path.Count - 1]));
            float distA = Vector2.Distance(currPos, path[path.Count - 1].transform.position);

            if (distA <= distTolerance)
            {
                reached = true;
                dumbCounter = 0;
            }

            //float distB = Vector2.Distance(currPos, gridManager.GridToWorld(path[nodeNum]));
            float distB = Vector2.Distance(currPos, path[nodeNum].transform.position);

            if (distB <= distTolerance && nodeNum < path.Count - 1)
            {
                ++nodeNum;
                dumbCounter = 0;
            }

            
        }
    }

    //Vector2 NewIdlePos()
    //{
    //    if (visted.Count == waypoints.Count)
    //    {
    //        visted.Clear();
    //    }

    //    GameObject bestTarget = null;
    //    float closestDistSq = Mathf.Infinity;
    //    Vector3 currPos = transform.position;

    //    foreach (GameObject wp in waypoints)
    //    {
    //        if (visted.Contains(wp) == false)
    //        {
    //            Vector3 directionToTarget = wp.transform.position - currPos;
    //            float distSqToTarget = directionToTarget.sqrMagnitude;

    //            if (distSqToTarget < closestDistSq)
    //            {
    //                closestDistSq = distSqToTarget;
    //                bestTarget = wp;
    //            }
    //        }
    //    }

    //    if (bestTarget != null)
    //    {
    //        visted.Add(bestTarget);
    //        return bestTarget.transform.position;
    //    }

    //    else return Vector2.zero;
    //}

    GameObject NewIdlePos()
    {
        if (visted.Count == waypoints.Count)
        {
            visted.Clear();
        }

        GameObject bestTarget = null;
        float closestDistSq = Mathf.Infinity;
        Vector3 currPos = transform.position;

        foreach (GameObject wp in waypoints)
        {
            if (visted.Contains(wp) == false)
            {
                Vector3 directionToTarget = wp.transform.position - currPos;
                float distSqToTarget = directionToTarget.sqrMagnitude;

                if (distSqToTarget < closestDistSq)
                {
                    closestDistSq = distSqToTarget;
                    bestTarget = wp;
                }
            }
        }

        if (bestTarget != null)
        {
            visted.Add(bestTarget);

            GameObject idlePos = gM.GetClosestNode(bestTarget.transform.position);
            return idlePos;
        }

        else return null;
    }

    public IEnumerator CDIdle()
    {
        yield return new WaitForSeconds(cdIdle);
        canIdle = true;
        reached = false;
    }

    public override void ResetStats()
    {
        canIdle = true;
        reached = false;

        if (path != null)
        {
            path.Clear();
        }

        nodeNum = 0;
        dumbCounter = 0;
        stuckCounter = 0;
    }

    bool IdlePath()
    {
        //path = gridManager.FindPath(gameObject, NewIdlePos());
        path = PathController.FindPath(gM.GetClosestNode(transform.position),  NewIdlePos());
        //++stuckCounter;

        dumbCounter = 0;
        nodeNum = 0;

        if (path == null || path.Count <= 0)
        {
            return false;
        }

        return true;
    }

    void StuckCheck()
    {
        if (stuckCounter >= stuckCheck)
        {

            Vector3 stuckPos = transform.position;

            //Point p = gridManager.WorldToGrid(transform.position);
            Vector3 unstuckPos = transform.position + new Vector3(0.1f, 0.1f, 0);

            //transform.position = Vector3.MoveTowards(transform.position, gridManager.GridToWorld(p), Time.deltaTime);
            transform.position = Vector3.MoveTowards(transform.position, unstuckPos, Time.deltaTime);

            if (transform.position != stuckPos)
            {
                stuckCounter = 0;
            }

        }
    }
}
