
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public  class EnemySoundController : MonoBehaviour
{
    /* 0 - growl
     * 1 - growlLong
     * 2 = toss
     */
    public AudioClip[] enemySounds;

    /* 0 - walk
     * 1 - chase
     */
    public AudioClip[] enemyMove;
    public AudioSource enemyWalk;
    public AudioSource enemySfx;

    public float maxDistMove;
    public float maxDistSkill;
    float currentDist;
    public GameObject player;

    private void Update()
    {
        currentDist = Vector3.Distance(transform.position, player.transform.position);
       
    }

    public void PlayGrowl()
    {
        enemySfx.clip = enemySounds[0];

        if (!enemySfx.isPlaying)
        {
            enemySfx.Play();
        }
        
    }

    public void PlayGrowlLong()
    {
        enemySfx.clip = enemySounds[1];

        if (!enemySfx.isPlaying)
        {
            enemySfx.Play();
        }
    }

    public void PlayToss()
    {
        enemySfx.clip = enemySounds[2];

        if (!enemySfx.isPlaying)
        {
            enemySfx.Play();
        }
    }

    public void PlayLand()
    {
        enemySfx.clip = enemySounds[3];

        if (!enemySfx.isPlaying)
        {
            enemySfx.Play();
        }
    }

    public void PlayWalk()
    {
        enemyWalk.pitch = 1f;
        enemyWalk.clip = enemyMove[0];

        enemyWalk.volume = (maxDistMove / currentDist) - 1;

        if (!enemyWalk.isPlaying)
        {
            enemyWalk.Play();
        }
    }

    public void PlaySearch()
    {
        enemyWalk.pitch = 0.8f;
        enemyWalk.clip = enemyMove[0];

        enemyWalk.volume = (maxDistMove / currentDist) - 1;

        if (!enemyWalk.isPlaying)
        {
            enemyWalk.Play();
        }
    }

    public void PlayChase()
    {
        enemyWalk.pitch = 1f;
        enemyWalk.clip = enemyMove[1];

        enemyWalk.volume = (maxDistMove / currentDist) - 1;

        if (!enemyWalk.isPlaying)
        {
            enemyWalk.Play();
        }
    }

    public void PlayAlert()
    {
        enemyWalk.pitch = 0.8f;
        enemyWalk.clip = enemyMove[1];

        enemyWalk.volume = (maxDistMove / currentDist) - 1;

        if (!enemyWalk.isPlaying)
        {
            enemyWalk.Play();
        }
    }
}

    

